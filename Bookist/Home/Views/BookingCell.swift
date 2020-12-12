import UIKit

class BookingCell: UITableViewCell, Component {
    
    static let identifier = "bookingCell"

    @IBOutlet weak var shuttleStackView: UIStackView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var campusNameLabel: UILabel!
    @IBOutlet weak var sessionTypeImageView: UIImageView!
    @IBOutlet weak var bookingStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    enum Configuration {
        case item(BookingModel)
    }
    
    func render(with configuration: Configuration) {
        if case let .item(booking) = configuration {
            setup(with: booking)
        }
    }
    
    private func setup(with booking: BookingModel) {
        setupLabels(with: booking)
        setupImages(with: booking.bookingType)
    }
    
    private func setupLabels(with booking: BookingModel) {
        guard let room = booking.room, let dateInfo = booking.dateInfo else { return }
        roomNameLabel.text = room.name
        campusNameLabel.text = room.campus.rawValue
        
        dayLabel.text = dateInfo.day
        startTimeLabel.text = dateInfo.startTime
        endTimeLabel.text = dateInfo.endTime
        
        shuttleStackView.isHidden = booking.shuttleBooking == nil
    }
    
    private func setupImages(with bookingType: BookingType) {
        let individualSessionImage = Constants.Image.individual
        let groupSessionImage = Constants.Image.group
        let sessionTypeImage = bookingType == .individual ? individualSessionImage : groupSessionImage
        sessionTypeImageView.image = sessionTypeImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
}
