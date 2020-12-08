import UIKit

protocol BookingViewControllerDelegate: class {
    
}

class BookingViewController: UIViewController {

    private let component: BookingView = create { $0.render(with: .individual) }
    
    weak var delegate: BookingViewControllerDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(delegate: BookingViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
    }
}
