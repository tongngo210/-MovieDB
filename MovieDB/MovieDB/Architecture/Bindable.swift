import UIKit

protocol Bindable {
    associatedtype ViewModel

    var viewModel: ViewModel! { get set }

    func bindViewModel()
}

extension Bindable where Self: UIViewController {
    mutating func set(viewModel: Self.ViewModel) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
