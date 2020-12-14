import UIKit

class BookingDetailsViewController: UIViewController {

    private var booking: BookingModel
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 20
    }
    
    private let layoutStackView: UIStackView = create {
        $0.alignment = .top
    }
    
    private let detailsStackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let viewTitle: Padded<Title> = createPadded {
        $0.render(with: .bigTitle)
    }
    
    private let detailsViewTitle: Padded<Title> = createPadded {
        $0.render(with: .plain("Details"))
    }
    
    private let detailsView: BookingDetailsView = create {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let shareLinkStack: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    private let shareLink: Button = create {
        $0.render(with: [.vertical(false), .image(Constants.Image.link), .text("Copy Link")])
    }
    
    private let closeButton: Padded<Button> = createPadded {
        $0.render(with: [.text(Constants.Text.close), .shadowed])
    }
    
    init(bookingModel: BookingModel) {
        self.booking = bookingModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewTitle.view.render(with: .plain(booking.bookingType == .group ? "Group Session" : "Individual Session"))
        detailsView.render(with: .booking(booking))
        shareLink.isHidden = booking.bookingType == .individual
    }
    
    private func setup() {
        
        view.backgroundColor = Constants.Color.theme
        view.addSubview(stackView)
        stackView.pinTo(safeArea: view)
        stackView.addArrangedSubview(viewTitle)
        stackView.addArrangedSubview(layoutStackView)
        layoutStackView.addArrangedSubview(detailsStackView)
        
        detailsStackView.addArrangedSubview(detailsViewTitle)
        detailsStackView.addArrangedSubview(detailsView)
        
        detailsStackView.addArrangedSubview(shareLinkStack)
        shareLinkStack.view.addArrangedSubview(shareLink)
        shareLink.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.addArrangedSubview(closeButton)
        closeButton.view.delegate = self
        
        closeButton.view.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
}

extension BookingDetailsViewController: ButtonDelegate {
    func didTapButton(_ sender: Button) {
        dismiss(animated: true, completion: nil)
    }
}
