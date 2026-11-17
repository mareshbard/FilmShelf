import UIKit
import SwiftUI
class ImageCell: UICollectionViewCell { // celula individual de uma grade ou lista
    static let identifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true // corta parte que ultrapassa o limite
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false // desativando layout padrao
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .purple
        contentView.layer.cornerRadius = 12
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    required init?(coder: NSCoder) {fatalError()}
    
    func configure(systemImageName: String) {
        imageView.image = UIImage(systemName: systemImageName)
    }
}

// preview usando uma conversao do SwiftUI
struct ImageCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> ImageCell {
        let cell = ImageCell(frame: CGRect(x: 0, y: 0, width: 130, height: 190))
        cell.configure(systemImageName: "popcorn.fill")
        return cell
    }
    
    func updateUIView(_ uiView: ImageCell, context: Context) {}
}

#Preview("Card de Imagem") {
    ImageCellRepresentable()
        .frame(width: 130, height: 190) // Define o tamanho do card no Canvas
        .padding()
}
