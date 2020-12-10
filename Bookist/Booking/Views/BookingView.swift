import UIKit

class BookingView: UIView, Component {
    
    private(set) var configuration: Configuration = .initial
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var title: Title = create {
        $0.render(with: .plain(self.titleLabelText))
        $0.render(with: .bigTitle)
    }
    
    var titleLabelText: String {
        return configuration == .group
            ? Constants.Text.groupBooking
            : Constants.Text.individualBooking
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Constants.Color.theme
        addSubview(stackView)
        stackView.pinTo(safeArea: self)
        stackView.addArrangedSubview(title)
    }
    
    enum Configuration {
        case initial
        case individual
        case group
    }
    
    func render(with configuration: Configuration) {
        switch configuration {
        case .initial: break
        case .individual: break
        case .group: break
        }
    }
}
