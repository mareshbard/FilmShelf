import UIKit

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    let sections = ["Destaques", "Lançamentos", "Em breve"]
    private let mockFilmesPorCategoria: [[String]] = [
            ["star.fill", "heart.fill", "bolt.fill", "flame.fill", "leaf.fill"],
            ["film", "tv", "video", "play.rectangle", "popcorn"],
            ["ticket", "sparkles", "crown", "moon.stars", "sun.max"]
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        // inicia collection view usando o tamanho da tela
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        //se girar:
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // collection pode se redimensionar de acordo com a tela
        
        // propria classe vai fornecer os dados por enquanto e tambem responder aos eventos da lista
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        // avisa quais classes usar pelo identificador
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.showsVerticalScrollIndicator = false 
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            
            // usa toda largura e altura permitida pelo grupo
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // define tamanho do card
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // cria section com as informacoes acima
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous  // faz os cards rolarem
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
            
            // configura e coloca um header no topo de cada section
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
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
        return mockFilmesPorCategoria[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // o que vai ser mostrado em cada item
        // inicia uma ImageCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        let iconeNome = mockFilmesPorCategoria[indexPath.section][indexPath.item]
        cell.configure(systemImageName: iconeNome) // imagens sendo colocadas
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // header de cada secao, do tipo HeaderSection
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
        header.titleLabel.text = sections[indexPath.section] // secoes sendo colocadas
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


#Preview {
    ContentViewController()
}
