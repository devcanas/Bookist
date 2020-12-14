import UIKit

protocol BookingViewDelegate: class {
    func didTapNextStepButton()
    func didTapPreviousStepButton()
}

protocol BookingViewProtocol: Component {
    var delegate: BookingViewDelegate? { get set }
    var collectionView: UICollectionView { get }
}

class BookingView: UIView, BookingViewProtocol {
    
    weak var delegate: BookingViewDelegate?
        
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 20
    }
    
    private let title: Padded<Title> = createPadded {
        $0.render(with: .bigTitle)
    }
    
    private(set) var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout())
    
    private let pageControl: UIPageControl = create {
        $0.currentPageIndicatorTintColor = Constants.Color.secondaryColor
        $0.pageIndicatorTintColor = .white
    }
    
    private let buttonStack: UIStackView = create {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 20
    }
    
    private var previousStepButtonWidthConstraint: NSLayoutConstraint? = nil
    private let previousStepButton: Button = create {
        $0.render(with: [.image(Constants.Image.arrowLeft), .shadowed])
        $0.isHidden = true
    }
    
    private let nextStepButton: Button = create {
        $0.render(with: [.text(Constants.Text.continueText), .shadowed])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
        
        previousStepButtonWidthConstraint = previousStepButton.widthAnchor.constraint(equalToConstant: .zero)
        previousStepButtonWidthConstraint?.isActive = true
        
        nextStepButton.delegate = self
        previousStepButton.delegate = self
    }
    
    func setButtonInactive(_ isInactive: Bool) {
        nextStepButton.render(with: .inactive(isInactive))
    }
    
    private func setup() {
        backgroundColor = Constants.Color.theme
        setupCollectionView()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    private func setupCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Constants.Color.theme
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(BookingViewCell.self, forCellWithReuseIdentifier: BookingViewCell.identifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(pageControl)
        
        buttonStack.addArrangedSubview(previousStepButton)
        buttonStack.addArrangedSubview(nextStepButton)
        stackView.addArrangedSubview(buttonStack)
    }
    
    private func setupSubviewsConstraints() {
        stackView.pinTo(safeArea: self)
        buttonStack.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    enum Configuration {
        case metadata(BookingJourneyMetadata)
    }
    
    func render(with configuration: Configuration) {
        if case let .metadata(metadata) = configuration {
            configure(with: metadata)
        }
    }
    
    private func configure(with metadata: BookingJourneyMetadata) {
        title.view.render(with: .plain(metadata.title))
        pageControl.numberOfPages = metadata.steps.count
        pageControl.currentPage = metadata.currentStep.rawValue
        configureButtons(with: metadata)
    }
    
    private func configureButtons(with metadata: BookingJourneyMetadata) {
        if metadata.currentStep.rawValue == 0 {
            hidePreviousStepButton()
        } else if metadata.currentStep.rawValue == metadata.steps.count - 2 {
            nextStepButton.render(with: .text(Constants.Text.confirm))
        } else if metadata.currentStep.rawValue == metadata.steps.count - 1 {
            nextStepButton.render(with: .text(Constants.Text.close))
            hidePreviousStepButton()
        } else {
            nextStepButton.render(with: .text(Constants.Text.continueText))
            showPreviousStepButton()
        }
    }
    
    private func showPreviousStepButton() {
        guard previousStepButton.isHidden else { return }
        previousStepButton.isHidden = false
        previousStepButtonWidthConstraint?.constant = 55
        UIView.animate(withDuration: 0.3, animations: {
            self.stackView.layoutIfNeeded()
        })
    }
    
    private func hidePreviousStepButton() {
        guard !previousStepButton.isHidden else { return }
        previousStepButtonWidthConstraint?.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.stackView.layoutIfNeeded()
        }, completion: { _ in
            self.previousStepButton.isHidden = true
            UIView.animate(withDuration: 0.11, delay: 0, options: .curveEaseOut, animations: {
                self.stackView.layoutIfNeeded()
            })
        })
    }
}

extension BookingView: ButtonDelegate {
    func didTapButton(_ sender: Button) {
        switch sender {
        case nextStepButton:
            delegate?.didTapNextStepButton()
        case previousStepButton:
            delegate?.didTapPreviousStepButton()
        default:
            break
        }
    }
}
