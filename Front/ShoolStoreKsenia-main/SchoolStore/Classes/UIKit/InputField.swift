
import AutoLayoutSugar
import Foundation
import UIKit

// MARK: - InputFieldProtocol

protocol InputFieldProtocol: AnyObject {
    var title: String? { get set }
    var error: String? { get set }
    var isSecure: Bool { get set }
    var text: String? { get set }
}

// MARK: - InputField

@IBDesignable
final class InputField: UIView, InputFieldProtocol {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Internal

    private(set) lazy var textField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title
            textField.placeholder = title
        }
    }

    var error: String? {
        didSet {
            let noError = error == nil
            errorView.isHidden = noError
            titleLabel.textColor = noError ? normalColor : errorColor
            errorLabel.text = error
            errorLabel.isHidden = (error ?? "").isEmpty
        }
    }

    @IBInspectable
    var isSecure: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecure
            textField.rightViewMode = isSecure ? .always : .never
        }
    }

    @IBInspectable
    var text: String? {
        get {
            textField.text
        }
        set {
            titleLabel.isHidden = (newValue ?? "").isEmpty
            textField.text = newValue
        }
    }

    // MARK: Private

    private let normalColor: UIColor = Asset.textPrimary.color.withAlphaComponent(0.87)

    private let errorColor: UIColor = Asset.fieldError.color

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var errorLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var errorView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var eyeView: UIView = {
        let eyeView = UIButton(frame: .init(x: 0, y: 0, width: 24, height: 24))
        eyeView.setImage(Asset.fieldEye.image, for: .normal)
        eyeView.addTarget(self, action: #selector(eyePressed), for: .touchUpInside)
        return eyeView
    }()

    @objc
    private func eyePressed() {
        guard isSecure else {
            return
        }
        textField.isSecureTextEntry.toggle()
    }

    private func setup() {
        makeSubviews()
        makeProperties()
        makeConstraints()
    }

    private func makeSubviews() {
        addSubview(backgroundView)
        addSubview(errorView)

        errorView.addArrangedSubview(bottomLine)
        errorView.addArrangedSubview(errorLabelContainer)

        errorLabelContainer.addSubview(errorLabel)

        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(textField)
    }

    private func makeProperties() {
        textField.delegate = self
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        errorView.axis = .vertical
        errorView.isHidden = true

        errorLabel.isHidden = true
        errorLabel.textColor = errorColor
        errorLabel.font = .systemFont(ofSize: 12)

        bottomLine.backgroundColor = errorColor

        titleLabel.textColor = normalColor
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.isHidden = true
        titleLabel.numberOfLines = 1

        textField.textColor = normalColor
        textField.font = .systemFont(ofSize: 16)
        textField.rightView = eyeView

        backgroundView.backgroundColor = Asset.fieldBacground.color
    }

    private func makeConstraints() {
        backgroundView.top().left().right().height(54)
        errorView.top(to: .bottom, of: backgroundView).left().right().bottom()
        errorLabel.top().left(16).right(16).bottom()
        bottomLine.height(1)
        titleLabel.top(6).right(16).left(16)
        textField.top(16).left(16).right(16).height(24)
    }
}

// MARK: UITextFieldDelegate

extension InputField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText: String
        if let oldText = textField.text as NSString? {
            newText = oldText.replacingCharacters(in: range, with: string) as String
        } else {
            newText = ""
        }
        titleLabel.isHidden = newText.isEmpty
        error = nil
        return true
    }
}
