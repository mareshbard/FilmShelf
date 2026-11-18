import UIKit

class SearchBar: UIView, UITextFieldDelegate {
    var searchText: String = ""
    var onSearch: ((String) -> Void)?
    var onClear: (() -> Void)? 
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .darkGray
        textField.layer.cornerRadius = 12
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowRadius = 5
        textField.layer.shadowOffset = CGSize(width: 0, height: 3)
        let placeholder = NSAttributedString(string: "Pesquise um filme", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16)])
        
        textField.attributedPlaceholder = placeholder
        textField.autocorrectionType = .no
        
        let iconSearch = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconSearch.contentMode = .scaleAspectFit
        iconSearch.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        iconSearch.tintColor = .gray
        textField.leftView = iconSearch
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // O Q MUDA AQUI?
        return textField
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.tintColor = .gray
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        //        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("inir has not been implemented")
    }
    
    private func setupView() {
        textField.delegate = self
        addSubview(textField)
        addSubview(clearButton)
        textField.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            clearButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -10),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        searchText = updatedText
        
        let trimmedText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        clearButton.isHidden = trimmedText.isEmpty
        
        if !trimmedText.isEmpty {
            onSearch?(trimmedText)
        } else {
            onClear?() // avisa que limpou
        }
        return true
    }
    
    @objc private func textFieldDidChange() {
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        clearButton.isHidden = trimmedText.isEmpty
        if trimmedText.isEmpty {
            onClear?()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // fecha o teclado
        return true
    }
    
    @objc private func clearButtonTapped() {
        textField.text = ""
        searchText = ""
        clearButton.isHidden = true
        onClear?()
        textField.resignFirstResponder()
    }
}
#Preview {
    SearchBar()
}
