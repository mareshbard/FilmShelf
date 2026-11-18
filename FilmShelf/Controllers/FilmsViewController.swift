import UIKit

class HomeViewController: UIViewController {
    private let homeView = FilmsView()
    let sections = ["Destaques", "Lançamentos", "Em breve", "Melhores avaliados"]
    
    private let service = TMDBService()
    private var moviesForCategory: [[Movie]] = [[], [], [], []]
    
    private var searchResults: [Movie]? = nil
    private var searchTask: Task<Void, Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        
        homeView.searchBar.onSearch = {[weak self] text in self?.search(text)}
        homeView.searchBar.onClear = { [weak self] in
            self?.clearSearch() // se limpar, clearSearch é avisado
        }
        loadData()
    }
    
    
    override func loadView() {
        // definindo a root view
        view = homeView
    }
    
    private var genreNames: [Int : String] = [:]

    private func search(_ text: String) {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else {return}
            
            do {
                let results = try await service.searchMovies(query: text)
                guard !Task.isCancelled else {return}
                searchResults = results
                homeView.collectionView.reloadData()
            } catch {
                print("Erro: ", error)
                
            }
        }
    }
    
    private func clearSearch() {
        searchTask?.cancel()
        searchResults = nil
        homeView.collectionView.reloadData()
    }
    private func loadData() {
        Task {
            do {
                // fazendo requisicoes para buscar categorias de filmes e generos
                async let destaques = service.fetchMovies(path: "movie/popular")
                async let lancamentos = service.fetchMovies(path: "movie/now_playing")
                async let embreve = service.fetchMovies(path: "movie/upcoming")
                async let melhores = service.fetchMovies(path: "movie/top_rated")
                async let genres = service.fetchGenres()
                
                let (d, l, e, m, g) = try await (destaques, lancamentos, embreve, melhores, genres)
                moviesForCategory = [d,l,e,m]
                genreNames = Dictionary(uniqueKeysWithValues: g.map {($0.id, $0.name)})
                
                homeView.collectionView.reloadData()
            } catch {
                print("Não foi possivel carregar filmes: ", error)
            }
        }
    }
}

// enquanto não preencher o contrato vai dar erro de não conformidade com o protocolo
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // qtd de secoes
        
        if searchResults != nil {
            return 1
        }
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let results = searchResults {
            return results.count
        }
        // numero de itens na secao
        return moviesForCategory[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // o que vai ser mostrado em cada item
        // inicia uma ImageCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        var movie: Movie
        if let results = searchResults {
            movie = results[indexPath.item]
        } else {
            movie = moviesForCategory[indexPath.section][indexPath.item]
        }
        
        cell.configure(with: movie) // imagens sendo colocadas
        return cell
    }
    
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == CreditsFooter.kind {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CreditsFooter.identifier, for: indexPath)
        }
        
        // header de cada secao, do tipo HeaderSection
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
        
        if searchResults != nil {
            header.titleLabel.text = "Resultados da pesquisa"
        } else {
            header.titleLabel.text = sections[indexPath.section] // secoes sendo colocadas
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie
        if let results = searchResults {
            movie = results[indexPath.item]
        } else {
            movie = moviesForCategory[indexPath.section][indexPath.item]
        }
        let detailVC = DetailViewController(movie: movie)
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }

}


#Preview {
    ContentViewController()
}
