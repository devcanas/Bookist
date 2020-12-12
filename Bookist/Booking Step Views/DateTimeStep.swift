import UIKit

class DateTimeStep: BookingStepView {
    override var step: BookingStep { .dateTime }
    
    override var canMoveForward: Bool { false }
    
    private let bookingDateStack: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let bookingDateTitle: Title = create {
        $0.render(with: .withImage(Constants.Text.dateAndTime, Constants.Image.clock))
    }
    
    private let bookingDatePickerStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 20
    }
    
    private let bookingDatePicker: UIDatePicker = create {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.setDate(Date(timeIntervalSinceNow: .zero), animated: false)
        $0.tintColor = Constants.Color.theme
        $0.backgroundColor = .white
    }
    
    private let bookingTimePicker: TimePicker = .loadFromNib()
    
    private let shuttleDateStack: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let shuttleDateTitle: Title = create {
        $0.render(with: .withImage(Constants.Text.shuttle, Constants.Image.shuttle))
    }
    
    private let shuttleTimeStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let shuttleTimePicker: TimePicker = .loadFromNib()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func render(with configuration: BookingStepView.Configuration) {
        super.render(with: configuration)
        configureViews()
        setupTimePickers()
    }
    
    private func configureViews() {
        shuttleDateStack.isHidden = model.shuttleBooking == nil
        guard let shuttleBooking = model.shuttleBooking else { return }
        shuttleTimePicker.endStackView.isHidden = !shuttleBooking.isRoundtrip
    }
    
    private func setup() {
        setupBookingDate()
        setupShuttleDate()
        setupTimePickers()
    }
    
    private func setupTimePickers() {
        setupBookingTimePicker()
        setupShuttleTimePicker()
    }
    
    private func setupBookingDate() {
        addArrangedSubview(bookingDateStack)
        bookingDateStack.addArrangedSubview(bookingDateTitle)
        bookingDateStack.addArrangedSubview(bookingDatePickerStack)
        bookingDatePickerStack.view.addArrangedSubview(bookingDatePicker)
        bookingDatePickerStack.view.addArrangedSubview(bookingTimePicker)
    }
    
    private func setupShuttleDate() {
        addArrangedSubview(shuttleDateStack)
        shuttleDateStack.addArrangedSubview(shuttleDateTitle)
        shuttleDateStack.addArrangedSubview(shuttleTimeStack)
        shuttleTimeStack.view.addArrangedSubview(shuttleTimePicker)
    }
    
    private func setupBookingTimePicker() {
        bookingTimePicker.render(with: [
            .labels("session start", "session end"),
            .startTime(Date(timeIntervalSinceNow: .zero)),
            .endTime(Date(timeIntervalSinceNow: .zero))
        ])
    }
    
    private func setupShuttleTimePicker() {
        guard let campus = model.campus?.rawValue else { return }
        shuttleTimePicker.render(with: [
            .labels("to \(campus)", "round trip"),
            .startTime(Date(timeIntervalSinceNow: .zero)),
            .endTime(Date(timeIntervalSinceNow: .zero))
        ])
    }
}
