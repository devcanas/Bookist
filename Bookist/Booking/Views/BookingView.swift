import UIKit

class BookingView: UIView, Component {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .red
    }
    
    enum Configuration {
        case individual
        case group
    }
    
    func render(with configuration: Configuration) {
        
    }
}
