import UIKit
import Foundation

protocol MVVMViewProtocol: NSObjectProtocol {
    associatedtype ViewProperties

    func bind(with viewModel: MVVMViewModel<ViewProperties>)
    func update(with properties: ViewProperties)
}


fileprivate var viewModelKey = "architectureViewModelKey"
extension MVVMViewProtocol {

    fileprivate var viewModel: MVVMViewModel<ViewProperties>? {
        get {
            return objc_getAssociatedObject(self, viewModelKey) as? MVVMViewModel<ViewProperties>
        }

        set {
            objc_setAssociatedObject(self, viewModelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func bind(with viewModel: MVVMViewModel<ViewProperties>) {
        self.viewModel?.removeSubscriber()
        self.viewModel = viewModel

        if let viewController = self as? UIViewController {
            let _ = viewController.view
        }

        viewModel.observe { [weak self] properties in
            if Thread.isMainThread {
                self?.update(with: properties)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.update(with: properties)
                }
            }
        }
    }

}

open class MVVMViewModel<ViewProperties> {
    typealias Subscriber = (ViewProperties) -> Void
    private var subscriber: Subscriber?
    fileprivate var viewProperties: ViewProperties?

    init() {}

    fileprivate func observe(with subscriber: @escaping Subscriber) {
        self.subscriber = subscriber
        
        guard let viewProperties = self.viewProperties else { return }
        notify(with: viewProperties)
    }
    
    fileprivate func removeSubscriber() {
        subscriber = nil
    }
    
    func notify(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties

        if Thread.isMainThread {
            subscriber?(viewProperties)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.subscriber?(viewProperties)
            }
        }

    }
}
