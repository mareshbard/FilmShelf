import Foundation

struct TMDBService {
    private let apiKey = "e3cbe1cb333096ca6b8e36814067398b"
    private var baseUrl = "https://api.themoviedb.org/3/"
    private let language = "pt-BR"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchMovies(path: String, page: Int = 1) async throws -> [Movie] {
        let url = try createurl(path: path, queryItems: [URLQueryItem(name: "page", value: String(page))])
        let response: MovieResponse = try await fetchData(from: url) // url com qtd de paginas
        return response.results
    }
    
    func fetchGenres(page: Int = 1) async throws -> [Genre] {
        let url = try createurl(path: "genre/movie/list")
        let response: GenreResponse = try await fetchData(from: url)
        return response.genres
    }
    
    func createurl(path: String, queryItems: [URLQueryItem] = []) throws -> URL {
        guard var components = URLComponents(string: baseUrl + path) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems + [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> [Movie] {
        let url = try createurl(path: "search/movie", queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page))
        ])
        let response: MovieResponse = try await fetchData(from: url)
        return response.results
    }
    
    // usa generics pra passar o que quiser aqui como o tipo de dado (filme, genero) a ser decodificado
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error: error)
        }
    }
}

