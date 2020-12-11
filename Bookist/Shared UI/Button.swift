import UIKit

class Button: UIButton, Component {

    enum Configuration {
        case text(String)
        case image(UIImage)
        case bordered(Bool)
        case inactive(Bool)
        case bold
        case shadowed
    }
    
    func render(with configuration: Configuration) {
        switch configuration {
        case let .text(text):
            buttonLabel.text = text
            buttonLabel.isHidden = false
        case let .image(image):
            buttonImageView.image = image
            buttonImageView.isHidden = false
        case .bordered(_):
            break
        case .inactive(_):
            break
        case .bold: break
        case .shadowed:
            setupShadow()
        }
        setupStackViewPadding()
    }
    
    func render(with configurations: [Configuration]) {
        configurations.forEach { render(with: $0) }
    }
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.heightAnchor.constraint(equalToConstant: 110).isActive = true
        $0.isUserInteractionEnabled = false
    }
    
    private let buttonImageView: UIImageView = create {
        $0.tintColor = Constants.Color.theme
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
        $0.isHidden = true
    }
    
    private let buttonLabel: UILabel = create {
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = Constants.Color.theme
        $0.isUserInteractionEnabled = false
        $0.isHidden = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .systemGray4 : .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }
    
    private func setup() {
        setupStyle()
        setupSubviews()
    }
    
    private func setupStyle() {
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        stackView.pinTo(self)
        stackView.addArrangedSubview(buttonImageView)
        stackView.addArrangedSubview(buttonLabel)
        buttonImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    // hack. Get rid of this
    private func setupStackViewPadding() {
        let padding: CGFloat = buttonImageView.isHidden || buttonLabel.isHidden ? 0 : 20
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
    }
}
