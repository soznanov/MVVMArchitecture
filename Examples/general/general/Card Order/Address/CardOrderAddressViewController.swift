import UIKit

class CardOrderAddressViewController: UIViewController, MVVMViewProtocol {

    struct ViewProperties {
        let country: LTGSelectField.ViewProperties
        let countryNote: String?
        
        let city: LTGTextField.ViewProperties
        let address: LTGTextField.ViewProperties
        let zip: LTGTextField.ViewProperties

        let button: ButtonViewProperties
    }

    private var properties: ViewProperties?
    func update(with properties: ViewProperties) {
        self.properties = properties

        country?.update(with: properties.country)
        countryNote?.text = properties.countryNote
        countryNote?.isHidden = properties.countryNote == nil

        city?.update(with: properties.city)
        address?.update(with: properties.address)
        zip?.update(with: properties.zip)

        button?.setTitle(properties.button.title, for: .normal)
    }

    @IBOutlet private weak var country: LTGSelectField?
    @IBOutlet private weak var countryNote: UILabel?

    @IBOutlet private weak var city: LTGTextField?
    @IBOutlet private weak var address: LTGTextField?
    @IBOutlet private weak var zip: LTGTextField?

    @IBOutlet private weak var button: UIButton?

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!

    @IBAction private func doneTap() {
        properties?.button.action()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        zip?.keyboardType = .numberPad
        zip?.returnKeyType = .send
        zip?.onReturnTap = { [weak self] in
            _ = self?.zip?.becomeFirstResponder()
        }

        city?.keyboardType = .alphabet
        city?.returnKeyType = .next
        city?.onReturnTap = { [weak self] in
            _ = self?.address?.becomeFirstResponder()
        }

        address?.keyboardType = .alphabet
        address?.returnKeyType = .next
        address?.onReturnTap = { [weak self] in
            self?.doneTap()
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = zip?.becomeFirstResponder()
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

}
