import UIKit

class Padded<T: UIView>: UIStackView {
    
    private(set) var view: T
    
    init(_ view: T) {
        self.view = view
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addArrangedSubview(view)
        translatesAutoresizingMaskIntoConstraints = false
        layoutMargins = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        isLayoutMarginsRelativeArrangement = true
    }
}
