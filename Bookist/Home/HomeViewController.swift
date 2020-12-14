import UIKit

class HomeViewController: UIViewController {
        
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    private let component: HomeView = create { _ in }
    
    private lazy var bookingsDataSource: BookingsDataSource = makeBookingsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.addSubview(component)
        component.pinTo(view)
        component.setupDelegates(with: self)
        
        viewModel.fetchBookingData()
    }
    
    private func presentBookingFlow(for bookingType: BookingType) {
        let bookingVC = BookingViewController(bookingType: bookingType, delegate: self)
        bookingVC.modalPresentationStyle = .formSheet
        present(bookingVC, animated: true, completion: nil)
    }
    
    private func presentRoomDetails(for model: BookingModel) {
        let roomDetailsVC = BookingDetailsViewController(bookingModel: model)
        roomDetailsVC.modalPresentationStyle = .formSheet
        present(roomDetailsVC, animated: true, completion: nil)
    }
    
    private func makeBookingsDataSource() -> BookingsDataSource {
        return BookingsDataSource(tableView: component.bookingsTableView, cellProvider: {
            (tableView, indexPath, filter) -> BookingCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookingCell.identifier, for: indexPath) as! BookingCell
            cell.render(with: .item(self.viewModel.items[indexPath.row]))
            cell.delegate = self
            return cell
        })
    }
    
    private func applyBookingsSnapshot(animated: Bool = true) {
        var snapshot = BookingsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items)
        bookingsDataSource.apply(snapshot)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didFetchBookingData() {
        applyBookingsSnapshot()
    }
}

extension HomeViewController: HomeViewDelegate {    
    func didTapIndividualBookingButton() {
        presentBookingFlow(for: .individual)
    }
    
    func didTapGroupBookingButton() {
        presentBookingFlow(for: .group)
    }
}

extension HomeViewController: BookingCellDelegate {
    func didTapCell(model: BookingModel) {
        presentRoomDetails(for: model)
    }
}

extension HomeViewController: BookingViewControllerDelegate {
    func didBookRoom(with model: BookingModel, in vc: UIViewController) {
        vc.dismiss(animated: true, completion: {
            bookingMockData.append(model)
            self.viewModel.fetchBookingData()
        })
    }
}
