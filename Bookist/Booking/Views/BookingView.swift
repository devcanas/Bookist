import UIKit

class BookingView: UIView, Component {
    
    private(set) var configuration: Configuration = .initial {
        didSet {
            title.view.render(with: .plain(self.titleLabelText))
        }
    }
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 20
    }
    
    private let title: Padded<Title> = createPadded {
        $0.render(with: .bigTitle)
    }
    
    private let buttonStack: UIStackView = create {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 20
    }
    
    private var previousButtonWidthConstraint: NSLayoutConstraint? = nil
    private let previousButton: Button = create {
        $0.render(with: [.image(Constants.Image.arrowLeft), .shadowed])
        $0.isHidden = true
    }
    
    private let continueButton: Button = create {
        $0.render(with: [.text("Continue"), .shadowed])
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: BookingCollectionViewLayout())
    
    var titleLabelText: String {
        return configuration == .group
            ? Constants.Text.groupBooking
            : Constants.Text.individualBooking
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
        
        previousButtonWidthConstraint = previousButton.widthAnchor.constraint(equalToConstant: .zero)
        previousButtonWidthConstraint?.isActive = true
        
        [continueButton, previousButton].forEach {
            $0.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        }
    }
    
    private func setup() {
        backgroundColor = Constants.Color.theme
        setupCollectionView()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = Constants.Color.theme
        collectionView.register(BookingViewCell.self, forCellWithReuseIdentifier: BookingViewCell.identifier)
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(collectionView)
        buttonStack.addArrangedSubview(previousButton)
        buttonStack.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(buttonStack)
    }
    
    private func setupSubviewsConstraints() {
        stackView.pinTo(safeArea: self)
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalToConstant: 55),
            previousButton.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    enum Configuration {
        case initial
        case individual
        case group
    }
    
    func render(with configuration: Configuration) {
        self.configuration = configuration
    }
    
    @objc
    func handleTap(_ sender: Button) {
        switch sender {
        case continueButton:
            show()
        case previousButton:
            hide()
        default:
            break
        }
    }
    
    func hide() {
        previousButtonWidthConstraint?.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.stackView.layoutIfNeeded()
        }, completion: { _ in
            self.previousButton.isHidden = true
            UIView.animate(withDuration: 0.11, delay: 0, options: .curveEaseOut, animations: {
                self.stackView.layoutIfNeeded()
            })
        })
    }
    
    func show() {
        previousButton.isHidden = false
        previousButtonWidthConstraint?.constant = 55
        UIView.animate(withDuration: 0.3, animations: {
            self.stackView.layoutIfNeeded()
        })
    }
}
