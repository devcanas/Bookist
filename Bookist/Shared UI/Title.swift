import UIKit

class Title: UIView, Component {
    
    private let stackView: UIStackView = create {
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.spacing = 10
    }
    
    private let imageView: UIImageView = create {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private(set) var titleLabel: UILabel = create {
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.font = .boldSystemFont(ofSize: 25)
    }

    enum Configuration {
        case bigTitle
        case plain(String)
        case withImage(String, UIImage)
    }
    
    func render(with configuration: Configuration) {
        imageView.image = nil
        switch configuration {
        case let .plain(titleLabelText):
            titleLabel.text = titleLabelText
        case let .withImage(titleLabelText, image):
            imageView.image = image
            titleLabel.text = titleLabelText
        case .bigTitle:
            titleLabel.font = .boldSystemFont(ofSize: 28)
        }
        configureSubviews()
    }
    
    private func configureSubviews() {
        addSubview(stackView)
        stackView.pinTo(self)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        imageView.isHidden = imageView.image === nil
    }
}
