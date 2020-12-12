protocol BookingViewModelDelegate: class {
    func didFetchBookingJourney()
    func didUpdateBookingJourney()
}

protocol BookingViewModelProtocol {
    var journey: BookingJourney? { get }
    func fetchBookingJourney(for bookingType: BookingType)
    func nextStep()
    func previousStep()
    func update(with model: BookingModel)
}

class BookingViewModel: BookingViewModelProtocol {
    var journey: BookingJourney?
    
    weak var delegate: BookingViewModelDelegate?
    private let dataSource: MockDataSource
    
    init(delegate: BookingViewModelDelegate, dataSource: MockDataSource = MockDataSource()) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    func fetchBookingJourney(for bookingType: BookingType) {
        journey = dataSource.fetchBookingJourney(for: bookingType)
        delegate?.didFetchBookingJourney()
    }
    
    // Add some additional checks to make sure required data is filled
    func nextStep() {
        guard let metadata = journey?.metadata,
              metadata.currentStep.rawValue + 1 < metadata.steps.count else { return }
        metadata.currentStep = metadata.steps[metadata.currentStep.rawValue + 1]
        delegate?.didUpdateBookingJourney()
    }
    
    // Add some additional checks to make sure required data is filled
    func previousStep() {
        guard let metadata = journey?.metadata,
              metadata.currentStep.rawValue > 0 else { return }
        metadata.currentStep = metadata.steps[metadata.currentStep.rawValue - 1]
        delegate?.didUpdateBookingJourney()
    }
    
    func update(with updatedModel: BookingModel) {
        guard let journey = journey else { return }
        journey.with(bookingModel: updatedModel)
        delegate?.didUpdateBookingJourney()
    }
}
