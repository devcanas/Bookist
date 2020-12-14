import UIKit

class ImagedView: UIStackView, Component {
    private let imageView: UIImageView = create {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private var view: UIView = create { _ in }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        spacing = 10
        alignment = .center
        addArrangedSubview(imageView)
        addArrangedSubview(view)
    }
    
    enum Configuration {
        case image(UIImage)
        case view(UIView)
    }
    
    func render(with configuration: Configuration) {
        switch configuration {
        case let .image(image):
            imageView.image = image
        case let .view(view):
            self.view.subviews.forEach { $0.removeFromSuperview() }
            self.view.addSubview(view)
            view.pinTo(self.view)
        }
    }
}

class BookingDetailsView: UIStackView, Component {
    private let detailsStackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 10
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let detailsView: UIView = create {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = Constants.Color.theme
    }
    
    private let roomName: Title = create { _ in }
    
    private lazy var campusHolder: ImagedView = makeImagedView(with: Constants.Image.campus, view: campusLabel)
    private lazy var bookingDateHolder: ImagedView = makeImagedView(with: Constants.Image.calendar, view: bookingDateLabel)
    private lazy var bookingTimeHolder: ImagedView = makeImagedView(with: Constants.Image.clock, view: bookingTimeLabel)
    private lazy var shuttleTimeHolder: ImagedView = makeImagedView(with: Constants.Image.shuttle, view: shuttleTimeLabel)
    
    private let campusLabel: UILabel = create {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 17)
    }
    
    private let bookingDateLabel: UILabel = create {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 17)
    }
    
    private let bookingTimeLabel: UILabel = create {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 17)
    }
    
    private let shuttleTimeLabel: UILabel = create {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 17)
    }
    
    private let filtersStackView: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
    }
    
    private let filtersTitle: Title = create {
        $0.render(with: [.withImage(Constants.Text.filters, Constants.Image.filters)])
        $0.titleLabel.font = .boldSystemFont(ofSize: 20)
    }
    
    private let filtersTableView: UITableView = create {
        $0.allowsSelection = false
        $0.separatorColor = .clear
        $0.backgroundColor = Constants.Color.theme
        $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
        $0.register(ConfirmFiltersCell.self, forCellReuseIdentifier: ConfirmFiltersCell.identifier)
    }
    
    private lazy var filtersDataSource = makeFiltersDataSource()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    enum Configuration {
        case booking(BookingModel)
    }
    
    func render(with configuration: Configuration) {
        if case let .booking(bookingModel) = configuration {
            configure(with: bookingModel)
            let isFiltersHidden = bookingModel.appliedFilters.count == 0
            filtersStackView.isHidden = isFiltersHidden
            if !isFiltersHidden {
                applyFiltersSnapshot(data: bookingModel.appliedFilters)
            }
        }
    }
    
    private func makeFiltersDataSource() -> ConfirmedFiltersDataSource {
        return ConfirmedFiltersDataSource(tableView: filtersTableView, cellProvider: {
            (tableView, indexPath, filter) -> ConfirmFiltersCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmFiltersCell.identifier, for: indexPath) as? ConfirmFiltersCell
            cell?.render(with: .text(filter.rawValue))
            return cell
        })
    }
    
    private func applyFiltersSnapshot(data: [Filter], animated: Bool = true) {
        var snapshot = ConfirmedFiltersSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        filtersDataSource.apply(snapshot)
    }
    
    private func makeImagedView(with image: UIImage, view: UIView) -> ImagedView {
        return create { $0.render(with: [
            .image(image),
            .view(view)
        ])}
    }
    
    private func configure(with bookingModel: BookingModel) {
        guard let room = bookingModel.room else { return }
        roomName.render(with: .plain(room.name))
        campusLabel.text = bookingModel.campus?.rawValue ?? bookingModel.room?.campus.rawValue
        bookingDateLabel.text = bookingModel.startDate?.dayLabelText
        bookingTimeLabel.text = "\(bookingModel.startDate?.hourLabelText ?? "") - \(bookingModel.endDate?.hourLabelText ?? "")"
        guard let shuttleBooking = bookingModel.shuttleBooking else {
            shuttleTimeHolder.isHidden = true
            return
        }
        shuttleTimeLabel.text = shuttleBooking.asDisplayableTime
    }
    
    private func setup() {
        axis = .vertical
        spacing = 20
        addArrangedSubview(detailsView)
        addArrangedSubview(filtersStackView)
        
        detailsView.addSubview(detailsStackView)
        detailsStackView.pinTo(detailsView)
        detailsStackView.addArrangedSubview(roomName)
        detailsStackView.addArrangedSubview(campusHolder)
        detailsStackView.addArrangedSubview(bookingDateHolder)
        detailsStackView.addArrangedSubview(bookingTimeHolder)
        detailsStackView.addArrangedSubview(shuttleTimeHolder)
                
        filtersStackView.view.addArrangedSubview(filtersTitle)
        filtersStackView.view.addArrangedSubview(filtersTableView)
    }
}
