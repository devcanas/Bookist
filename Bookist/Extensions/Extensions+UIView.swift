import UIKit

protocol Component {
    associatedtype Configuration
    func render(with configuration: Configuration)
    func render(with configurations: [Configuration])
}

extension Component {
    func render(with configurations: [Configuration]) { }
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
