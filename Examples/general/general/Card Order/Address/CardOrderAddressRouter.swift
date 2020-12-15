import UIKit

final class CardOrderAddressRouter: CardOrderAddressViewModelRouterProtocol {

    private let completion: Closure
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, completion: @escaping Closure) {
        self.completion = completion
        self.navigationController = navigationController
    }

    func showWallettoEnterAddress(with cardType: CardType, address: CardOrderAddressModel) {
        let viewController = CardOrderAddressViewController(nibName: nil, bundle: nil)
        let viewModel = CardOrderAddressViewModel(
            cardType: cardType,
            address: address,
            updateService: MVVMService<CardOrderAddressModel, Void>(with: { (object, completion) in

                // MVVMService can be autogenerated from Swagger scheme or another declarative language
                // MVVMService allows to mock for unit-test without any extra classes
                // for test just need to set next code

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    completion(.success(()))
                }

            }),
            router: self)
        viewController.bind(with: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showCountrySelector(_ didSelect: @escaping (String?) -> ()) {

    }

    func enterAddressDidFinish() {
        completion()
    }

    func showAlertOnTop(text: String, style: MVVMAlertingStyle) {

    }

    func showAlertOnTop(text: String, style: MVVMAlertingStyle, actionTitle: String?, action: Closure?) {

    }

    func showProgress() {

    }

    func hideProgress() {
        
    }

}