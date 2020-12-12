import UIKit

protocol BookingStepViewDelegate: class {
    func didUpdateStep(with model: BookingModel, in step: BookingStep)
}

protocol BookingStepProtocol {
    var canMoveForward: Bool { get }
}

class BookingStepView: UIStackView, Component, BookingStepProtocol {
    
    var step: BookingStep { .location }
    var canMoveForward: Bool { false }
    
    weak var delegate: BookingStepViewDelegate?
    internal var model: BookingModel
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        self.model = BookingModel()
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 20
    }
    
    enum Configuration {
        case model(BookingModel)
    }
    
    func render(with configuration: Configuration) {
        if case let .model(model) = configuration {
            self.model = model
        }
    }
}
