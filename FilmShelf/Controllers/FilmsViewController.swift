import UIKit

class HomeViewController: UIViewController {
    private let homeView = FilmsView()
    let sections = ["Destaques", "Lançamentos", "Em breve", "Melhores avaliados"]
    
    private let service = TMDBService()
    private var moviesForCategory: [[Movie]] = [[], [], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        loadData()
    }
    
    override func loadView() {
        // definindo a root view
        view = homeView
    }
    
    private var genreNames: [Int : String] = [:]

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
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // numero de itens na secao
        return moviesForCategory[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // o que vai ser mostrado em cada item
        // inicia uma ImageCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        let movie = moviesForCategory[indexPath.section][indexPath.item]
        cell.configure(with: movie) // imagens sendo colocadas
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == CreditsFooter.kind {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CreditsFooter.identifier, for: indexPath)
        }
        
        // header de cada secao, do tipo HeaderSection
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
        header.titleLabel.text = sections[indexPath.section] // secoes sendo colocadas
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = moviesForCategory[indexPath.section][indexPath.item]
        let genres = movie.genreIds?.compactMap({genreNames[$0]})
        print(movie.title, genres)

    }

}


#Preview {
    ContentViewController()
}
