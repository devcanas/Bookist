import UIKit

protocol BookingViewControllerDelegate: class {
    
}

class BookingViewController: UIViewController {

    private(set) var component: BookingView = create { $0.render(with: .initial) }
    
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
        view.addSubview(component)
        component.pinTo(view)
    }
}
