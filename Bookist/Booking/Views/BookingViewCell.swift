import UIKit

class BookingViewCell: UICollectionViewCell, Component {
    static let identifier = "bookingViewCell"
    private(set) var configuration: Configuration = .initial
    private let layoutStackView: UIStackView = create { $0.alignment = .top }
    private let stackView: UIStackView = create { $0.spacing = 20 }
    
    
    
    enum Configuration {
        case initial
        case location
        case dateTime
        case roomChoice
        case confirm
        case groupAlert
    }
    
    func render(with configuration: Configuration) {
        self.configuration = configuration
        switch configuration {
        case .initial: break
        case .location: break
        case .dateTime: break
        case .roomChoice: break
        case .confirm: break
        case .groupAlert: break
        }
    }
}
