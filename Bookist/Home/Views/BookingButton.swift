import UIKit

class BookingButton: Button {
    
    enum Configuration {
        case individual
        case group
    }
    
    func render(with configuration: Configuration) {
        let text = buttonLabelText(for: configuration)
        let image = buttonImage(for: configuration)
        super.render(with: configurations(with: text, image: image))
    }
    
    private func configurations(with text: String, image: UIImage) -> [Button.Configuration] {
        return [.text(text), .image(image), .shadowed]
    }
    
    private func buttonLabelText(for configuration: Configuration) -> String {
        return configuration == .individual
            ? Constants.Text.individual
            : Constants.Text.group
    }
    
    private func buttonImage(for configuration: Configuration) -> UIImage {
        return configuration == .individual
            ? Constants.Image.individual
            : Constants.Image.group
    }
}
