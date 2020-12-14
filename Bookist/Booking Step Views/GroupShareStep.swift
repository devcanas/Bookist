import UIKit

class GroupShareStep: BookingStepView {
    override var step: BookingStep { .groupShareStep }
    override var canMoveForward: Bool { true }
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let title: Padded<Title> = createPadded {
        $0.render(with: .withImage(Constants.Text.confirmBooking, Constants.Image.confirm))
    }
    
    private let messageStackView: Padded<UIStackView> = createPadded {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 20
    }
    
    private let messageIcon: UIImageView = create {
        $0.image = Constants.Image.confirmFilter
        $0.tintColor = .systemGreen
    }
    
    private let messageLabel: UILabel = create {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .white
        $0.numberOfLines = .zero
        $0.text = "You are all set, you can now find your new booking in the 'Up Next' section of the home screen!"
    }
    
    private let shareLink: Button = create {
        $0.isHidden = true
        $0.render(with: [.vertical(false), .image(Constants.Image.link), .text("Copy Link")])
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func render(with configuration: BookingStepView.Configuration) {
        super.render(with: configuration)
        if case let .journey(journey) = configuration {
            if journey.metadata.bookingType == .group {
                shareLink.isHidden = false
                messageIcon.image = Constants.Image.excl
                messageIcon.tintColor = .systemOrange
                messageLabel.text = "You have until 2 hours before the group session starts to have other people join this session. Share the session link!"
            }
        }
    }
    
    private func configureViews() {
    }
    
    private func setup() {
        setupSubviews()
    }
    
    func setupSubviews() {
        addArrangedSubview(stackView)
        stackView.addArrangedSubview(title)
        
        stackView.addArrangedSubview(messageStackView)
        messageStackView.view.addArrangedSubview(messageIcon)
        messageStackView.view.addArrangedSubview(messageLabel)
        messageStackView.view.addArrangedSubview(shareLink)
        
        messageStackView.view.setCustomSpacing(30, after: messageLabel)
        
        shareLink.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        messageIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7).isActive = true
    }
}
