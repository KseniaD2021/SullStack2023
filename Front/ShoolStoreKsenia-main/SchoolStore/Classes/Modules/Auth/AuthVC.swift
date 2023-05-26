
import UIKit

class AuthVC: UIViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.addSubview(indicator)
        indicator.topAnchor.constraint(equalTo: signInButton.topAnchor).activate()
        indicator.centerX().centerY()
        localizable()
    }

    // MARK: Internal

    func setup(with authService: AuthService, _ snacker: Snacker) {
        self.authService = authService
        self.snacker = snacker
    }

    @IBAction func signInPressed(_: Any) {
        guard let user = loginField.text, let password = passwordField.text else {
            return
        }
        if user.isEmpty {
            loginField.error = L10n.Common.emptyField
        }
        if password.isEmpty {
            passwordField.error = L10n.Common.emptyField
        }

        if (!user.isEmpty && !password.isEmpty) {
            authService?.authenticate(user: user, password: password, completion: { [weak self] (result: Result<AuthResponse, Error>) in
                switch result {
                case .success:
                    self!.indicator.startAnimating()
                    self!.signInButton.setTitle("", for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController = VCFactory.buildTabBarVC()
                    })


                case let .failure(error):
                    self?.handle(error: error)
                    self!.indicator.stopAnimating()
                }
            })
        }
    }

    @IBOutlet var loginField: InputField!

    @IBOutlet var passwordField: InputField!

    @IBOutlet var signInButton: UIButton!

    // MARK: Private
    
    private lazy var indicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.color = .white
            return indicator
        }()

    private var snacker: Snacker?

    private var authService: AuthService?
    
    private let dataService: DataService = CoreFactory.dataService

    private func handle(error: Error) {
        snacker?.show(snack: error.localizedDescription, with: .error)
        if let networkError = error as? Errors {
            switch networkError {
            case let .failedResponse(_, fields):
                fields?.forEach { field in
                    switch field.field {
                    case "login":
                        self.loginField.error = field.message
                        fallthrough
                    case "password":
                        self.passwordField.error = field.message
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }

    private func localizable() {
        loginField.title = L10n.Auth.login
        passwordField.title = L10n.Auth.password
        signInButton.setTitle(L10n.Auth.action, for: .normal)
    }
}
