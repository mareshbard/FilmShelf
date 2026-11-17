import UIKit
import SwiftUI
class ImageCell: UICollectionViewCell { // celula individual de uma grade ou lista
    static let identifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true // corta parte que ultrapassa o limite
        iv.tintColor = .systemBlue
        iv.translatesAutoresizingMaskIntoConstraints = false // desativando layout padrao
        return iv
    }()
    
    private var imageTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .purple
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true // para corner radius funcionar
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    required init?(coder: NSCoder) {fatalError()}
    
    func configure(with movie: Movie) {
        imageView.image = nil
        imageTask?.cancel()
        
        guard let url = movie.posterURL else {return}
        
        imageTask = Task {
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  !Task.isCancelled else {return}
            imageView.image = UIImage(data: data)
            
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageView.image = nil
    }
}

// preview usando uma conversao do SwiftUI
//struct ImageCellRepresentable: UIViewRepresentable {
//    func makeUIView(context: Context) -> ImageCell {
//        let cell = ImageCell(frame: CGRect(x: 0, y: 0, width: 130, height: 190))
//        cell.configure(systemImageName: "popcorn.fill")
//        return cell
//    }
//    
//    func updateUIView(_ uiView: ImageCell, context: Context) {}
//}
//
//#Preview("Card de Imagem") {
//    ImageCellRepresentable()
//        .frame(width: 130, height: 190) // Define o tamanho do card no Canvas
//        .padding()
//}
