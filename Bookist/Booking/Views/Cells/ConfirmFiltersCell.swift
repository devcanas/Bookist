import UIKit

class ConfirmFiltersCell: UITableViewCell, Component {
    
    static let identifier = "ConfirmedFiltersCell"
    
    private let view: ImagedView = create { _ in }
    
    private let label: UILabel = create {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            view.render(with: [.image(Constants.Image.confirmFilter), .view(label)])
        }
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}
