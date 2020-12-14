import UIKit

class FiltersCell: UICollectionViewCell, Component {
    
    static let identifier = "FiltersCell"
    
    private let label: UILabel = create {
        $0.textAlignment = .center
        $0.backgroundColor = Constants.Color.theme
        $0.textColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 10
        $0.font = .systemFont(ofSize: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    override var isSelected: Bool {
        didSet {
            label.backgroundColor = isSelected ? .white : Constants.Color.theme
            label.textColor = isSelected ? Constants.Color.theme : .white
        }
    }

    enum Configuration {
        case text(String)
    }
    
    func render(with configuration: Configuration) {
        if case let .text(text) = configuration {
            label.text = text
        }
    }
    
    private func setup() {
        layer.cornerRadius = 10
        clipsToBounds = true
        contentView.addSubview(label)
        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.pinTo(contentView)
    }
}
