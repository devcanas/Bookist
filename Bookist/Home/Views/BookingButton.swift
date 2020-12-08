//
//  BookingButton.swift
//  Bookist
//
//  Created by Vicente Canas on 05/12/2020.
//

import UIKit

class BookingButton: UIButton, Component {
    
    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 5
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    private let buttonImageView: UIImageView = create {
        $0.tintColor = Constants.Color.theme
        $0.contentMode = .scaleAspectFit
    }
    
    private let buttonLabel: UILabel = create {
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textAlignment = .center
        $0.textColor = Constants.Color.theme
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        setupStyle()
        setupSubviews()
    }
    
    func setupStyle() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.cornerRadius = 10
        layer.shadowOffset = .zero
    }
    
    func setupSubviews() {
        addSubview(stackView)
        stackView.pinTo(self)
        stackView.addArrangedSubview(buttonImageView)
        stackView.addArrangedSubview(buttonLabel)
    }
    
    enum Configuration {
        case individual
        case group
    }
    
    func render(with configuration: Configuration) {
        let text = buttonLabelText(for: configuration)
        let image = buttonImage(for: configuration)
        setButton(with: text, and: image)
    }
    
    private func buttonLabelText(for configuration: Configuration) -> String {
        return configuration == .individual
            ? Constants.Text.individual
            : Constants.Text.group
    }
    
    private func buttonImage(for configuration: Configuration) -> UIImage? {
        return configuration == .individual
            ? Constants.Image.individual
            : Constants.Image.group
    }
    
    private func setButton(with labelText: String, and image: UIImage?) {
        buttonLabel.text = labelText
        buttonImageView.image = image
    }
}
