import UIKit

class LocationStep: BookingStepView {
    
    override var step: BookingStep { .location }
    
    override var canMoveForward: Bool {
        return model.campus != nil
    }

    private let campusStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let campusTitle: Title = create {
        $0.render(with: .withImage(Constants.Text.campus, Constants.Image.campus))
    }
    
    private let campusButtonsStack: UIStackView = create {
        $0.spacing = 10
        $0.axis = .vertical
    }
    
    private let alamedaButton: Button = create {
        $0.render(with: [.text(Constants.Text.alameda), .bold, .bordered(true)])
    }
    
    private let tagusparkButton: Button = create {
        $0.render(with: [.text(Constants.Text.taguspark), .bold, .bordered(true)])
    }
    
    private let shuttleStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let shuttleTitle: Title = create {
        $0.render(with: [.withImage(Constants.Text.shuttle, Constants.Image.shuttle)])
    }
    
    private let shuttleButtonsStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    private let shuttleBookingRadioYes: SmallButton = create { $0.render(with: .radio("Yes")) }
    private let shuttleBookingRadioNo: SmallButton = create { $0.render(with: .radio("No")) }
    private let shuttleRoundTripCheck: SmallButton = create {
        $0.render(with: .checkbox("Roundtrip?"))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func render(with configuration: Configuration) {
        super.render(with: configuration)
        configure(with: model.campus)
        configure(with: model.shuttleBooking)
    }
    
    private func configure(with campus: Campus?) {
        guard let campus = campus else { return }
        let isAlamedaSelected = campus == .alameda
        let isTagusparkSelected = campus == .taguspark
        alamedaButton.render(with: .bordered(!isAlamedaSelected))
        tagusparkButton.render(with: .bordered(!isTagusparkSelected))
    }
    
    private func configure(with shuttleBooking: ShuttleBooking?) {
        shuttleBookingRadioNo.isChecked = shuttleBooking == nil
        shuttleBookingRadioYes.isChecked = shuttleBooking != nil
        shuttleRoundTripCheck.isHidden = shuttleBooking == nil
        guard let isRoundTrip = shuttleBooking?.isRoundtrip else { return }
        shuttleRoundTripCheck.isChecked = isRoundTrip
    }
        
    @objc
    private func handleShuttleButtonPress(_ sender: SmallButton) {
        switch sender {
        case shuttleRoundTripCheck:
            model.shuttleBooking?.isRoundtrip.toggle()

        case shuttleBookingRadioNo:
            guard model.shuttleBooking != nil else { return }
            model.shuttleBooking = nil

        case shuttleBookingRadioYes:
            guard model.shuttleBooking == nil else { return }
            model.shuttleBooking = ShuttleBooking(to: model.campus)
        default:
            break
        }
        delegate?.didUpdateStep(with: model, in: step)
    }
    
    private func setup() {
        setupCampusStack()
        setupShuttleStack()
        setupSubviewsConstraints()
        setupActions()
    }
    
    private func setupCampusStack() {
        addArrangedSubview(campusStack)
        campusStack.view.addArrangedSubview(campusTitle)
        campusStack.view.addArrangedSubview(campusButtonsStack)
        campusButtonsStack.addArrangedSubview(alamedaButton)
        campusButtonsStack.addArrangedSubview(tagusparkButton)
    }
    
    private func setupShuttleStack() {
        addArrangedSubview(shuttleStack)
        shuttleStack.view.addArrangedSubview(shuttleTitle)
        shuttleStack.view.addArrangedSubview(shuttleButtonsStack)
        
        shuttleButtonsStack.view.addArrangedSubview(shuttleBookingRadioYes)
        shuttleButtonsStack.view.addArrangedSubview(shuttleBookingRadioNo)
        shuttleButtonsStack.view.addArrangedSubview(shuttleRoundTripCheck)
        shuttleButtonsStack.view.setCustomSpacing(30, after: shuttleBookingRadioNo)
    }
    
    private func setupSubviewsConstraints() {
        NSLayoutConstraint.activate([
            alamedaButton.heightAnchor.constraint(equalToConstant: 85),
            tagusparkButton.heightAnchor.constraint(equalTo: alamedaButton.heightAnchor)
        ])
    }
    
    private func setupActions() {
        alamedaButton.delegate = self
        tagusparkButton.delegate = self
        
        shuttleRoundTripCheck.addTarget(self, action: #selector(handleShuttleButtonPress(_:)), for: .touchUpInside)
        shuttleBookingRadioYes.addTarget(self, action: #selector(handleShuttleButtonPress(_:)), for: .touchUpInside)
        shuttleBookingRadioNo.addTarget(self, action: #selector(handleShuttleButtonPress(_:)), for: .touchUpInside)
    }
}

extension LocationStep: ButtonDelegate {
    func didTapButton(_ sender: Button) {
        switch sender {
        case alamedaButton:
            model.campus = .alameda
            break
        case tagusparkButton:
            model.campus = .taguspark
            break
        default:
            break
        }
        
        if let shuttleBooking = model.shuttleBooking {
            let updatedShuttleBooking = ShuttleBooking(to: model.campus)
            model.shuttleBooking = updatedShuttleBooking
            model.shuttleBooking?.isRoundtrip = shuttleBooking.isRoundtrip
        }
        
        delegate?.didUpdateStep(with: model, in: step)
    }
}
