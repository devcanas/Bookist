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
            roomNameLabel.text = booking.room.name
            campusNameLabel.text = booking.room.campus.rawValue
            
            dayLabel.text = booking.dateInfo.day
            startTimeLabel.text = booking.dateInfo.startTime
            endTimeLabel.text = booking.dateInfo.endTime
            
            shuttleStackView.isHidden = booking.shuttleBooking == nil
            
            let individualSessionImage = Constants.Image.individual
            let groupSessionImage = Constants.Image.group
            let sessionTypeImage = booking.bookingType == .individual ? individualSessionImage : groupSessionImage
            sessionTypeImageView.image = sessionTypeImage
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
}
