import UIKit

class ConfirmationStep: BookingStepView {
    override var step: BookingStep { .confirm }
    override var canMoveForward: Bool { true }
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let title: Padded<Title> = createPadded {
        $0.render(with: .withImage(Constants.Text.confirmBooking, Constants.Image.confirm))
    }
    
    private let detailsView: BookingDetailsView = create {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func render(with configuration: BookingStepView.Configuration) {
        super.render(with: configuration)
        if case let .journey(journey) = configuration {
            detailsView.render(with: .booking(journey.bookingModel))
        }
    }
    
    private func configureViews() {
    }
    
    private func setup() {
        setupSubviews()
    }
    
    func setupSubviews() {
        addArrangedSubview(stackView)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(detailsView)
    }
}
