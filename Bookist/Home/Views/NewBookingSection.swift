import UIKit

protocol NewBookingSectionDelegate: class {
    func didTapIndividualBookingButton()
    func didTapGroupBookingButton()
}

class NewBookingSection: UIView {
    
    weak var delegate: NewBookingSectionDelegate?
    
    private let stackview: UIStackView = create {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    private let btnsStackView: UIStackView = create {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    private let title: Title = create { $0.render(with: .plain(Constants.Text.newBooking)) }
    private let individualBookingBtn: BookingButton = create { $0.render(with: .individual) }
    private let groupBookingBtn: BookingButton = create { $0.render(with: .group) }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupActions()
    }
    
    private func setupSubviews() {
        self.addSubview(stackview)
        stackview.pinTo(self)
        stackview.addArrangedSubview(title)
        stackview.addArrangedSubview(btnsStackView)
        btnsStackView.addArrangedSubview(individualBookingBtn)
        btnsStackView.addArrangedSubview(groupBookingBtn)
    }
    
    private func setupActions() {
        individualBookingBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        groupBookingBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
    }
    
    @objc
    private func handleTap(_ sender: UIButton) {
        switch sender {
        case individualBookingBtn:
            delegate?.didTapIndividualBookingButton()
        case groupBookingBtn:
            delegate?.didTapGroupBookingButton()
        default:
            break
        }
    }
}
