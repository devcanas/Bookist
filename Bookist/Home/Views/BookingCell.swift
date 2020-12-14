import UIKit

protocol BookingCellDelegate: class {
    func didTapCell(model: BookingModel)
}

class BookingCell: UITableViewCell, Component {
    
    static let identifier = "bookingCell"
    
    weak var delegate: BookingCellDelegate?

    @IBOutlet weak var shuttleStackView: UIStackView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var campusNameLabel: UILabel!
    @IBOutlet weak var sessionTypeImageView: UIImageView!
    @IBOutlet weak var bookingStatusImageView: UIImageView!
    @IBOutlet weak var bookingStatusColor: UIView!
    
    private var booking: BookingModel?
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = .clear
            contentView.backgroundColor = .clear
            contentView.layer.backgroundColor = UIColor.clear.cgColor
            layer.backgroundColor = UIColor.clear.cgColor
            selectedBackgroundView?.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        booking = nil
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
        self.booking = booking
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        setupLabels(with: booking)
        setupImages(with: booking.bookingType)
    }
    
    @objc
    private func handleTap() {
        guard let booking = booking else { return }
        delegate?.didTapCell(model: booking)
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
        bookingStatusImageView.image = bookingType == .individual ? nil : Constants.Image.excl
        bookingStatusColor.backgroundColor = bookingType == .individual ? .systemGreen : .systemOrange
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
}
