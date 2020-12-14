import UIKit

typealias HomeViewDelegate = NewBookingSectionDelegate & UITableViewDelegate

class HomeView: UIView, Component {

    private let stackView: UIStackView = create {
        $0.layoutMargins = UIEdgeInsets(top: 100, left: 20, bottom: .zero, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let newBookingSection: NewBookingSection = create { _ in }
    
    private let bookingsStackView: UIStackView = create {
        $0.axis = .vertical
    }
    private let bookingsTitle: Title = create { $0.render(with: .plain(Constants.Text.upNext)) }
    private(set) var bookingsTableView: UITableView = create {
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
        $0.allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Constants.Color.theme
        setupSubviews()
    }
    
    enum Configuration {
        case initial
        case items([BookingModel])
    }
    
    func render(with configuration: Configuration) {
        switch configuration {
        case .initial: break
        case let .items(bookings):
            print(bookings)
        }
    }
    
    func setupDelegates(with viewController: HomeViewDelegate) {
        newBookingSection.delegate = viewController
        bookingsTableView.delegate = viewController
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        setupStackView()
        setupBookingsStackView()
    }
    
    private func setupStackView() {
        stackView.pinTo(safeArea: self)
        stackView.addArrangedSubview(newBookingSection)
        stackView.addArrangedSubview(bookingsStackView)
    }
    
    private func setupBookingsStackView() {
        bookingsStackView.addArrangedSubview(bookingsTitle)
        bookingsStackView.addArrangedSubview(bookingsTableView)
        
        bookingsTableView.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: BookingCell.identifier)
    }
}
