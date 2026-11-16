import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {fatalError()} // PROIBE DE USAR CELULA EM UM STORYBOARD
}

// Preview para o SectionHeader

import SwiftUI
struct SectionHeaderRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> SectionHeader {
        let header = SectionHeader(frame: CGRect(x: 0, y: 0, width: 350, height: 40))
        header.titleLabel.text = "Filmes populares" // Testa o texto do título
        return header
    }
    
    func updateUIView(_ uiView: SectionHeader, context: Context) {}
}

#Preview("Cabeçalho de Seção") {
    SectionHeaderRepresentable()
//        .frame(width: 350, height: 40)
        .padding()
}
