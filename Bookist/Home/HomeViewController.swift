import UIKit

class HomeViewController: UIViewController {
        
    private let viewModel: HomeViewModelProtocol = HomeViewModel()
    private let component: HomeView = create { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension HomeViewController: HomeViewModelDelegate {
    func didFetchBookingData() {
        component.bookingsTableView.reloadData()
    }
}

extension HomeViewController: HomeViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookingCell.identifier, for: indexPath) as! BookingCell
        cell.render(with: .item(viewModel.items[indexPath.section]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return create { $0.backgroundColor = .clear }
    }
    
    func didTapIndividualBookingButton() {
        presentBookingFlow(for: .individual)
    }
    
    func didTapGroupBookingButton() {
        presentBookingFlow(for: .group)
    }
}

extension HomeViewController: BookingViewControllerDelegate {
    
}
