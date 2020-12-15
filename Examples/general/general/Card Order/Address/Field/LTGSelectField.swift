import UIKit

class LTGSelectField: UIView, MVVMViewProtocol {

    struct ViewProperties {
        let title: String
        let value: String?
        let click: Closure
    }

    private var properties: ViewProperties?
    func update(with properties: ViewProperties) {
        self.properties = properties
        title.text = properties.title
        value.text = properties.value
    }

    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 12)
        title.textColor = UIColor.black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private let value: UILabel = {
        let value = UILabel()
        value.font = UIFont.systemFont(ofSize: 15)
        value.textColor = UIColor.black
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.setContentHuggingPriority(.required, for: .vertical)

        addSubview(value)
        value.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        value.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        value.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        value.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        addSubview(button)
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }

    @objc private func buttonDidTap() {
        properties?.click()
    }

}
