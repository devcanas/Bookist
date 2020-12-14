import UIKit

protocol ButtonDelegate: class {
    func didTapButton(_ sender: Button)
}

class Button: UIButton, Component {
    
    weak var delegate: ButtonDelegate?

    enum Configuration {
        case text(String)
        case image(UIImage)
        case bordered(Bool)
        case inactive(Bool)
        case vertical(Bool)
        case noBackground
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
        case let .vertical(vertical):
            configureVertical(vertical)
        case .noBackground:
            layer.borderWidth = .zero
            isUserInteractionEnabled = false
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
    
    private var buttonImageViewWidthAnchor: NSLayoutConstraint?
    private var buttonImageViewHeightAnchor: NSLayoutConstraint?
    
    override var isHighlighted: Bool {
        didSet {
            let defaultColor = layer.borderWidth == 2 ? Constants.Color.theme : .white
            backgroundColor = isHighlighted ? .systemGray4 : defaultColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @objc
    private func handleTap() {
        delegate?.didTapButton(self)
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
        buttonImageView.tintColor = bordered ? .white : Constants.Color.theme
        layer.borderWidth = bordered ? 2 : 0
        layer.borderColor = bordered ? UIColor.white.cgColor : UIColor.clear.cgColor
    }
    
    private func configureInactive(_ inactive: Bool) {
        isUserInteractionEnabled = !inactive
        backgroundColor = inactive ? UIColor.white.withAlphaComponent(0.6) : .white
    }
    
    private func configureVertical(_ vertical: Bool) {
        stackView.axis = vertical ? .vertical : .horizontal
        buttonLabel.font = .boldSystemFont(ofSize: vertical ? 17 : 15)
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
        setupActions()
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
        buttonImageViewWidthAnchor = buttonImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5)
        buttonImageViewHeightAnchor = buttonImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5)
        
        buttonImageViewWidthAnchor?.isActive = true
    }
    
    private func setupActions() {
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    // hack. Get rid of this
    private func setupStackViewPadding() {
        if stackView.axis == .vertical {
            let padding: CGFloat = buttonImageView.isHidden || buttonLabel.isHidden ? 0 : 20
            buttonImageViewWidthAnchor?.isActive = true
            stackView.layoutMargins = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        } else {
            buttonImageViewWidthAnchor?.isActive = false
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
}
