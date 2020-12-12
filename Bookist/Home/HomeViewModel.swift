protocol HomeViewModelDelegate: class {
    func didFetchBookingData()
}

protocol HomeViewModelProtocol {
    var items: [BookingModel] { get }
    func fetchBookingData()
}

class HomeViewModel: HomeViewModelProtocol {
    
    var items: [BookingModel] = []
    
    weak var delegate: HomeViewModelDelegate?
    private let dataSource: MockDataSource
    
    init(dataSource: MockDataSource = MockDataSource()) {
        self.dataSource = dataSource
    }
    
    func fetchBookingData() {
        items = dataSource.fetchBookingData()
        delegate?.didFetchBookingData()
    }
}
