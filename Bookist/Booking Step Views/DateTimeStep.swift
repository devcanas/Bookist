import UIKit

class DateTimeStep: BookingStepView {
    override var step: BookingStep { .dateTime }
    
    override var canMoveForward: Bool {
        guard let startDate = model.startDate,
              let endDate = model.endDate,
              let diff = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour
        else {
            return false
        }
        
        return diff >= 1
    }
    
    private let bookingDateStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let bookingDateTitle: Title = create {
        $0.render(with: .withImage(Constants.Text.dateAndTime, Constants.Image.calendar))
    }
    
    private let bookingDatePickerStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 20
    }
    
    private let bookingDatePicker: UIDatePicker = create {
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .date
        $0.tintColor = Constants.Color.theme
        $0.backgroundColor = .white
    }
    
    private let bookingTimePicker: TimePicker = .loadFromNib()
    
    private let shuttleDateStack: Padded<UIStackView> = createPadded {
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
        setupActions()
    }
    
    private func setupBookingDate() {
        addArrangedSubview(bookingDateStack)
        bookingDateStack.view.addArrangedSubview(bookingDateTitle)
        bookingDateStack.view.addArrangedSubview(bookingDatePickerStack)
        bookingDatePickerStack.view.addArrangedSubview(bookingDatePicker)
        bookingDatePickerStack.view.addArrangedSubview(bookingTimePicker)
    }
    
    private func setupShuttleDate() {
        addArrangedSubview(shuttleDateStack)
        shuttleDateStack.view.addArrangedSubview(shuttleDateTitle)
        shuttleDateStack.view.addArrangedSubview(shuttleTimeStack)
        shuttleTimeStack.view.addArrangedSubview(shuttleTimePicker)
    }
    
    private func setupTimePickers() {
        setupBookingDatePicker()
        setupBookingTimePicker()
        setupShuttleTimePicker()
    }
    
    private func setupActions() {
        bookingDatePicker.addTarget(self, action: #selector(handleDateChanged(_:)), for: .editingDidEnd)
    }
    
    @objc
    private func handleDateChanged(_ sender: UIDatePicker) {
        let now = Date(timeIntervalSinceNow: .zero)
        let day = sender.date.get(.day, calendar: .current)
        model.startDate = (model.startDate ?? now).replacingDay(with: day)
        model.endDate = (model.endDate ?? now).replacingDay(with: day)
        delegate?.didUpdateStep(with: model, in: step)
    }
    
    private func setupBookingDatePicker() {
        let now = Date(timeIntervalSinceNow: .zero)
        bookingDatePicker.setDate(model.startDate ?? now, animated: false)
    }
    
    private func setupBookingTimePicker() {
        let now = Date(timeIntervalSinceNow: .zero)
        bookingTimePicker.delegate = self
        bookingTimePicker.render(with: [
            .labels("session start", "session end"),
            .startTime(model.startDate ?? now),
            .endTime(model.endDate ?? now)
        ])
    }
    
    private func setupShuttleTimePicker() {
        let now = Date(timeIntervalSinceNow: .zero)
        shuttleTimePicker.delegate = self
        shuttleTimePicker.render(with: [
            .labels("to \(model.shuttleBooking?.to?.rawValue ?? "")", "round trip"),
            .startTime(model.shuttleBooking?.toTime ?? now),
            .endTime(model.shuttleBooking?.fromTime ?? now)
        ])
    }
}

extension DateTimeStep: TimePickerDelegate {
    func didChangeStartTime(time: Date, in picker: TimePicker) {
        if picker == bookingTimePicker {
            model.startDate = time
        } else {
            model.shuttleBooking?.toTime = time
        }
        delegate?.didUpdateStep(with: model, in: step)
    }
    
    func didChangeEndTime(time: Date, in picker: TimePicker) {
        if picker == bookingTimePicker {
            model.endDate = time
        } else {
            model.shuttleBooking?.fromTime = time
        }
        delegate?.didUpdateStep(with: model, in: step)
    }
    
    func displayPickerError(message: String) {
        // show toast maybe
    }
}
