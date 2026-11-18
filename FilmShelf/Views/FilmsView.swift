import UIKit

class FilmsView: UIView {

    var collectionView: UICollectionView!
    let searchBar = SearchBar()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var genreNames: [Int : String] = [:]
    
    private func setupCollectionView() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        // inicia collection view usando o tamanho da tela
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        //se girar:
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // collection pode se redimensionar de acordo com a tela
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // avisa quais classes usar pelo identificador
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(CreditsFooter.self, forSupplementaryViewOfKind: CreditsFooter.kind, withReuseIdentifier: CreditsFooter.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    

    private func createLayout() -> UICollectionViewLayout {

            
            let config = UICollectionViewCompositionalLayoutConfiguration()
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
            
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: CreditsFooter.kind, alignment: .bottom)
        config.boundarySupplementaryItems = [footer]
        
        return UICollectionViewCompositionalLayout(sectionProvider:  { _, _ in
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
        }, configuration: config) // usa as configs e coloca o footer embaixo
    
    }
}


#Preview {
    ContentViewController()
}
