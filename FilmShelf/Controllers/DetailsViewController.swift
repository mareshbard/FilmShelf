import UIKit

class DetailViewController: UIViewController {
    
    private let movie: Movie
    
    private let posterView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.backgroundColor = .systemPurple
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {fatalError()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        navigationItem.title = movie.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .prominent, target: self, action: #selector(addMovie))
        setupUI()
        loadImage()
    }
    
    @objc func addMovie() {
        print(movie.title)
    }
    
    func setupUI() {
        overviewLabel.text = movie.overview
        
        view.addSubview(posterView)
        view.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterView.widthAnchor.constraint(equalToConstant: 180),
            posterView.heightAnchor.constraint(equalToConstant: 270),
            
            overviewLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func loadImage() {
        guard let url = movie.posterURL else {return}
         Task {
             guard let (data, _) = try? await URLSession.shared.data(from: url) else {return}
            let image = UIImage(data: data)
             posterView.image = image // mandando poster pra viu
        }
    }
}


#Preview {
    let movie = Movie(id: 1, title: "Emma", overview: "Jane Austen's book", releaseDate: "2020", posterPath: nil, genreIds: nil)
    DetailViewController(movie: movie)
}
