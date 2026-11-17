import UIKit

class CreditsFooter: UICollectionReusableView {
    static let identifier = "CreditsFooter"
    static let kind = "credits-footer"
    
    private let logo: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "TMDB"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "This product uses the TMDB API but is not endorsed or certified by TMDB."
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [logo, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: 50),
            logo.heightAnchor.constraint(equalToConstant: 20),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
