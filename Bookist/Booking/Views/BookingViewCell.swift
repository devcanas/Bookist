import UIKit

class BookingViewCell: UICollectionViewCell, Component {
    static let identifier = "bookingViewCell"
    private let layoutStackView: Padded<UIStackView> = createPadded { $0.alignment = .top }
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private(set) lazy var currentStepView: BookingStepView = locationStep
    
    private let locationStep: LocationStep = create { $0.isHidden = true }
    private let dateTimeStep: DateTimeStep = create { $0.isHidden = true }
    private let roomChoiceStep: RoomChoiceStep = create { $0.isHidden = true }
    private let confirmationStep: ConfirmationStep = create { $0.isHidden = true }
    private let groupShareStep: GroupShareStep = create { $0.isHidden = true }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(layoutStackView)
        layoutStackView.pinTo(self)
        layoutStackView.view.addArrangedSubview(stackView)
        setupStepViews()
    }
    
    private func setupStepViews() {
        stackView.addArrangedSubview(locationStep)
        stackView.addArrangedSubview(dateTimeStep)
        stackView.addArrangedSubview(roomChoiceStep)
        stackView.addArrangedSubview(confirmationStep)
        stackView.addArrangedSubview(groupShareStep)
    }
    
    enum Configuration {
        case configuration(BookingStep, BookingModel)
    }
    
    func render(with configuration: Configuration) {
        if case let .configuration(step, model) = configuration {
            currentStepView.isHidden = true
            currentStepView = getCurrentView(for: step)
            currentStepView.isHidden = false
            currentStepView.render(with: .model(model))
        }
    }
    
    private func getCurrentView(for step: BookingStep) -> BookingStepView {
        switch step {
        case .location:
            return locationStep
        case .dateTime:
            return dateTimeStep
        case .roomChoice:
            return roomChoiceStep
        case .confirm:
            return confirmationStep
        case .groupShareStep:
            return groupShareStep
        }
    }
}
