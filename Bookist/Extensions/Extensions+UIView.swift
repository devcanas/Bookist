import UIKit

protocol Component {
    associatedtype Configuration
    func render(with configuration: Configuration)
    func render(with configurations: [Configuration])
}

extension Component {
    func render(with configurations: [Configuration]) {
        configurations.forEach { render(with: $0) }
    }
}

func createPadded<T: UIView>(_ completion: @escaping (T) -> Void) -> Padded<T> {
    let view: T = create { _ in }
    let paddedView = Padded<T>(view)
    completion(view)
    return paddedView
}

func create<T: UIView>(_ completion: @escaping (T) -> Void) -> T {
    let view: T = T()
    view.translatesAutoresizingMaskIntoConstraints = false
    completion(view)
    return view
}



extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        let xib = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)
        let view = xib![0] as! T
        return view
    }
    
    func pinTo(_ view: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func pinTo(safeArea view: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
