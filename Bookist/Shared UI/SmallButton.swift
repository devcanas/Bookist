import UIKit

class SmallButton: UIButton, Component {
    
    private let stackView: UIStackView = create {
        $0.spacing = 10
        $0.alignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    private let buttonView: UIView = create {
        $0.backgroundColor = Constants.Color.theme
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.isUserInteractionEnabled = false
    }
    
    private let buttonCheckedView: UIView = create {
        $0.backgroundColor = .white
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
    }
    
    private let buttonTitleLabel: UILabel = create {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .white
        $0.isUserInteractionEnabled = false
    }
    
    var isChecked: Bool = false {
        didSet {
            buttonCheckedView.isHidden = !isChecked
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            buttonView.alpha = isHighlighted ? 0.7 : 1
        }
    }
    
    enum Configuration {
        case radio(String)
        case checkbox(String)
    }
    
    func render(with configuration: Configuration) {
        switch configuration {
        case let .radio(text):
            buttonTitleLabel.text = text
            buttonView.layer.cornerRadius = 15
            buttonCheckedView.layer.cornerRadius = 10
        case let .checkbox(text):
            buttonTitleLabel.text = text
            buttonView.layer.cornerRadius = 10
            buttonCheckedView.layer.cornerRadius = 5
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubview(stackView)
        stackView.pinTo(self)
        stackView.addArrangedSubview(buttonView)
        buttonView.addSubview(buttonCheckedView)
        stackView.addArrangedSubview(buttonTitleLabel)
        
        NSLayoutConstraint.activate([
            buttonCheckedView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            buttonCheckedView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            
            buttonCheckedView.widthAnchor.constraint(equalToConstant: 20),
            buttonCheckedView.heightAnchor.constraint(equalToConstant: 20),
            
            buttonView.widthAnchor.constraint(equalToConstant: 30),
            buttonView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
