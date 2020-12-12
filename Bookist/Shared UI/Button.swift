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
            configure(with: text)
        case let .image(image):
            configure(with: image)
        case let .bordered(bordered):
            configureBordered(bordered)
        case let .inactive(inactive):
            configureInactive(inactive)
        case .bold: break
        case .shadowed:
            configureShadowed()
        }
        setupStackViewPadding()
    }
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
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
    
    private var buttonImageViewHeightAnchor: NSLayoutConstraint?
    
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
    
    private func configure(with text: String) {
        buttonLabel.text = text
        buttonLabel.isHidden = false
        if !buttonImageView.isHidden {
            buttonImageViewHeightAnchor?.isActive = true
        }
    }
    
    private func configure(with image: UIImage) {
        buttonImageView.image = image
        buttonImageView.isHidden = false
        if !buttonLabel.isHidden {
            buttonImageViewHeightAnchor?.isActive = true
        }
    }
    
    private func configureBordered(_ bordered: Bool) {
        backgroundColor = bordered ? Constants.Color.theme : .white
        buttonLabel.textColor = bordered ? .white : Constants.Color.theme
        layer.borderWidth = bordered ? 2 : 0
        layer.borderColor = bordered ? UIColor.white.cgColor : UIColor.clear.cgColor
    }
    
    private func configureInactive(_ inactive: Bool) {
        isUserInteractionEnabled = !inactive
        backgroundColor = inactive ? UIColor.white.withAlphaComponent(0.6) : .white
    }
    
    private func configureShadowed() {
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
        buttonImageViewHeightAnchor = buttonImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5)
    }
    
    // hack. Get rid of this
    private func setupStackViewPadding() {
        let padding: CGFloat = buttonImageView.isHidden || buttonLabel.isHidden ? 0 : 20
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
    }
}
