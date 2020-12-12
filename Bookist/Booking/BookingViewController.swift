import UIKit

protocol BookingViewControllerDelegate: class {
    
}

class BookingViewController: UIViewController {

    weak var delegate: BookingViewControllerDelegate?
    private lazy var viewModel = BookingViewModel(delegate: self)
    
    private let component: BookingView = create { _ in }
    private(set) var bookingType: BookingType
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(bookingType: BookingType, delegate: BookingViewControllerDelegate) {
        self.bookingType = bookingType
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            view.setNeedsLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.fetchBookingJourney(for: bookingType)
    }
    
    private func setup() {
        view.addSubview(component)
        component.pinTo(view)
        component.delegate = self
        component.collectionView.delegate = self
        component.collectionView.dataSource = self
    }
}

extension BookingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.journey?.metadata.steps.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookingViewCell.identifier, for: indexPath) as! BookingViewCell
        if let step = viewModel.journey?.metadata.steps[indexPath.row], let model = viewModel.journey?.bookingModel {
            cell.render(with: .configuration(step, model))
            cell.currentStepView.delegate = self
            component.setButtonInactive(!cell.currentStepView.canMoveForward)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return component.collectionView.frame.size
    }
}

extension BookingViewController: BookingViewDelegate {
    func didTapNextStepButton() {
        viewModel.nextStep()
    }
    
    func didTapPreviousStepButton() {
        viewModel.previousStep()
    }
}

extension BookingViewController: BookingStepViewDelegate {
    func didUpdateStep(with model: BookingModel, in step: BookingStep) {
        viewModel.update(with: model)
    }
}

extension BookingViewController: BookingViewModelDelegate {
    func didFetchBookingJourney() {
        guard let journey = viewModel.journey else { return }
        component.render(with: .metadata(journey.metadata))
    }
    
    func didUpdateBookingJourney() {
        guard let journey = viewModel.journey else { return }
        component.render(with: .metadata(journey.metadata))
        let newIndexPath = IndexPath(row: journey.metadata.currentStep.rawValue, section: .zero)
        component.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        component.collectionView.reloadData()
    }
}
