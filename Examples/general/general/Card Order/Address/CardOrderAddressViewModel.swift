import Foundation

protocol CardOrderAddressViewModelRouterProtocol: MVVMAlertingProtocol, MVVMProcessingProtocol {
    func showCountrySelector(_ didSelect: @escaping (_ country: String?) -> ())
    func enterAddressDidFinish()
}

final class CardOrderAddressViewModel: MVVMViewModel<CardOrderAddressViewController.ViewProperties> {

    private let cardType: CardType
    private var address: CardOrderAddressModel
    private let updateService: MVVMService<CardOrderAddressModel, Void>
    private let router: CardOrderAddressViewModelRouterProtocol

    init(cardType: CardType,
         address: CardOrderAddressModel,
         updateService: MVVMService<CardOrderAddressModel, Void>,
         router: CardOrderAddressViewModelRouterProtocol) {

        self.cardType = cardType
        self.address = address
        self.updateService = updateService
        self.router = router

        super.init()
        notify()
    }

    private func notify() {
        let countryNote: String?
        let doneButton: String

        switch cardType {
        case .plastic:
            countryNote = "Shipping rates may vary depending on the delivery address for your order"
            doneButton = "Send to this address"
        case .virtual:
            countryNote = nil
            doneButton = "Save address"
        }

        notify(with: CardOrderAddressViewController.ViewProperties(
                country: LTGSelectField.ViewProperties(
                    title: "Country",
                    value: address.country,
                    click: { [weak self] in
                        self?.router.showCountrySelector { [weak self] country in
                            self?.address.country = country
                            self?.notify()
                        }
                    }),
                countryNote: countryNote,
                city: LTGTextField.ViewProperties(
                    title: "City",
                    value: address.city,
                    onDidChange: { [weak self] in
                        self?.update(value: $0, field: \.city, maxLength: 70, characterSet: CardOrderAddressViewModel.availableCitySet)
                    }),
                address: LTGTextField.ViewProperties(
                    title: "Address",
                    value: address.address,
                    onDidChange: { [weak self] in
                        self?.update(value: $0, field: \.address, maxLength: 70, characterSet: CardOrderAddressViewModel.availableAddressSet)
                    }),
                zip: LTGTextField.ViewProperties(
                    title: "Postal Code",
                    value: address.zip,
                    onDidChange: { [weak self] in
                        self?.update(value: $0, field: \.zip, maxLength: 10, characterSet: CardOrderAddressViewModel.availableZipSet)
                    }),
                button: ButtonViewProperties(
                    title: doneButton,
                    action: { [weak self] in
                        self?.setAddress()
                    })))
    }

    private static let availableZipSet = CharacterSet(charactersIn: "0123456789").inverted
    private static let availableCitySet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXUZabcdefghijklmnopqrstuvwxyz.,- ").inverted
    private static let availableAddressSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXUZabcdefghijklmnopqrstuvwxyz0123456789.,#-/ ").inverted

    private func update(value: String?, field: WritableKeyPath<CardOrderAddressModel, String?>, maxLength: Int?, characterSet: CharacterSet?) {
        guard var validValue = value else { return notify() }

        if let maxLength = maxLength {
            validValue = String(validValue.prefix(maxLength))
        }

        if let characterSet = characterSet {
            validValue = validValue.trimmingCharacters(in: characterSet)
        }

        address[keyPath: field] = validValue

        if value != validValue { notify() }
    }


    private func setAddress() {
        router.showProgress()
        updateService.execute(with: address) { result in
            self.router.hideProgress()

            switch result {
            case .success:
                self.router.enterAddressDidFinish()

            case .failure(let error):
                self.router.showAlertOnTop(text: error.localizedDescription, style: .red)
            }
        }
    }
}
