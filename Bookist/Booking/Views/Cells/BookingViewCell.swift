import UIKit

class BookingViewCell: UICollectionViewCell, Component {
    static let identifier = "bookingViewCell"
    private let layoutStackView: UIStackView = create { $0.alignment = .top }
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private(set) var currentStepView = BookingStepView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func setup() {
        addSubview(layoutStackView)
        layoutStackView.pinTo(self)
        layoutStackView.addArrangedSubview(stackView)
    }
    
    enum Configuration {
        case configuration(BookingStepView, BookingJourney)
    }
    
    func render(with configuration: Configuration) {
        if case let .configuration(stepView, journey) = configuration {
            currentStepView = stepView
            stackView.addArrangedSubview(stepView)
            currentStepView.render(with: .journey(journey))
        }
    }
}
