import UIKit

protocol TimePickerDelegate: class {
    func didChangeStartTime(time: Date, in picker: TimePicker)
    func didChangeEndTime(time: Date, in picker: TimePicker)
    func displayPickerError(message: String)
}

class TimePicker: UIStackView, Component {
    
    weak var delegate: TimePickerDelegate?
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var endStackView: UIStackView!
    
    override func awakeFromNib() {
        startTime.tintColor = Constants.Color.theme
        startTime.backgroundColor = .white
        endTime.tintColor = Constants.Color.theme
        endTime.backgroundColor = .white
    }
    
    enum Configuration {
        case startTime(Date)
        case endTime(Date)
        case labels(String, String)
    }
    
    func render(with configuration: Configuration) {
        switch configuration {
        case let .startTime(time):
            startTime.date = time
        case let .endTime(time):
            endTime.date = time
        case let .labels(startLabel, endLabel):
            self.startLabel.text = startLabel
            self.endLabel.text = endLabel
        }
    }
    @IBAction func handleTimeChanged(_ sender: UIDatePicker) {
        switch sender {
        case startTime:
            delegate?.didChangeStartTime(time: startTime.date, in: self)
        case endTime:
            delegate?.didChangeEndTime(time: endTime.date, in: self)
        default: break
        }
    }
}
