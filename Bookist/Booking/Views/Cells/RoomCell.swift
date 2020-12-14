import UIKit

class RoomCell: UICollectionViewCell {

    static let identifier = "RoomCell"
    
    private let layoutStackView: UIStackView = create {
        $0.alignment = .center
        
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
    }
    
    private let roomScheduleLabel: UILabel = create {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private let roomNameLabel: UILabel = create {
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.font = .boldSystemFont(ofSize: 17)
    }
    
    private let roomCampusLabel: UILabel = create {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .white : Constants.Color.theme
            roomScheduleLabel.textColor = isSelected ? Constants.Color.theme : .white
            roomNameLabel.textColor = isSelected ? Constants.Color.theme : .white
            roomCampusLabel.textColor = isSelected ? Constants.Color.theme : .white
        }
    }

    enum Configuration {
        case room(Room)
    }
    
    func render(with configuration: Configuration) {
        if case let .room(room) = configuration {
            roomScheduleLabel.text = "9h00 - 19h00"
            roomNameLabel.text = room.name
            roomCampusLabel.text = room.campus.rawValue
        }
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
        
        contentView.addSubview(layoutStackView)
        layoutStackView.pinTo(contentView)
        layoutStackView.addArrangedSubview(stackView)
        
        stackView.addArrangedSubview(roomScheduleLabel)
        stackView.addArrangedSubview(roomNameLabel)
        stackView.addArrangedSubview(roomCampusLabel)
        
        stackView.setCustomSpacing(10, after: roomScheduleLabel)
    }
}
