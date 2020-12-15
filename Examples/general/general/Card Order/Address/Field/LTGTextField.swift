import UIKit

class LTGTextField: UIView, MVVMViewProtocol, UITextFieldDelegate {

    struct ViewProperties {
        let title: String
        let value: String?
        let onDidChange: ClosureObject<String?>?
    }

    private var properties: ViewProperties?
    func update(with properties: ViewProperties) {
        self.properties = properties
        title.text = properties.title
        textField.text = properties.value
    }

    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 12)
        title.textColor = UIColor.black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = UIColor.black
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.setContentHuggingPriority(.required, for: .vertical)

        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }

    @objc private func textFieldDidChange() {
        properties?.onDidChange?(textField.text)
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    var onReturnTap: Closure?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturnTap?()
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
}
