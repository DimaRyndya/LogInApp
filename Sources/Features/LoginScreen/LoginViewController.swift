import UIKit

class LoginViewController: UIViewController {

    var viewModel: LoginViewModel!

    // MARK: - IBOutlets

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var checkBoxButtonLabel: UIButton!
    @IBOutlet weak var loginButtonLabel: UIButton!
    @IBOutlet weak var privacyLabel: UITextView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        view.backgroundColor = UIColor(red: 221 / 255, green: 254 / 255, blue: 221 / 255, alpha: 1)

        privacyLabel.attributedText = getLinkFromText(text: privacyLabel.text!)
        privacyLabel.isUserInteractionEnabled = true

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]

        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: attributes)
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: userPasswordTextField.placeholder!, attributes: attributes)

        privacyLabel.delegate = self
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self
        checkBoxButtonLabel.isSelected = false
        loginButtonLabel.isEnabled = false

    }

    // MARK: - IBAction methods

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let userName = userNameTextField.text, let password = userPasswordTextField.text else { return }
        
        viewModel.loginService.saveChache(userName: userName, password: password)

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let tabBarVC = sceneDelegate.rootVCBuilder.buildTabBarViewController(loginService: viewModel.loginService)
            UIView.transition(with: sceneDelegate.window ?? UIWindow(), duration: 0.5, options: [.transitionCurlDown], animations: {
                sceneDelegate.window?.rootViewController = tabBarVC
            }, completion: nil)
        }
    }

    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        checkBoxButtonLabel.isSelected = !checkBoxButtonLabel.isSelected

        if checkBoxButtonLabel.isSelected {
            checkBoxButtonLabel.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            loginButtonLabel.isEnabled = true
        } else {
            checkBoxButtonLabel.setImage(UIImage(systemName: "square"), for: .normal)
            loginButtonLabel.isEnabled = false
        }
    }


    // MARK: - Helper methods

    func getLinkFromText(text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let privacyRange = (attributedString.string as NSString).range(of: "Privacy Policy")
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]
        attributedString.addAttributes(linkAttributes, range: privacyRange)
        let url = URL(string: "https://redwing-studio.com/")
        attributedString.addAttribute(.link, value: url as Any, range: privacyRange)

        privacyLabel.attributedText = attributedString

        return attributedString
    }

    @objc func handleTap() {
        view.endEditing(true)
    }
}

    // MARK: - UIText View Delegate methods

extension LoginViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
            return false
    }
}

    // MARK: - UIText Field Delegate methods

extension LoginViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == userNameTextField || textField == userPasswordTextField else { return }
        guard let text = textField.text else { return }

        if textField == userNameTextField {
            validateUsername(text)
        } else {
            validatePassword(text)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }

    // MARK: - Validation methods

        func validateUsername(_ username: String) {
            guard let userName = userNameTextField.text else { return }

            if userName.count < 6 {
                print("Username must be at least 6 characters long")
            }
        }

        func validatePassword(_ password: String) {
            guard let password = userPasswordTextField.text else { return }

            let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

            if !passwordPredicate.evaluate(with: password) {
                print("Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit")
            }
        }
}
