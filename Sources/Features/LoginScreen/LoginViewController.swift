import UIKit

class LoginViewController: UIViewController {

    var viewModel: LoginViewModel!

    // MARK: - IBOutlets

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var checkBoxButtonLabel: UIButton!
    @IBOutlet weak var loginButtonLabel: UIButton!
    @IBOutlet weak var privacyLabel: UITextView!
    @IBOutlet weak var userNameValidationLabel: UILabel!
    @IBOutlet weak var userPasswordValidationLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        view.backgroundColor = UIColor(red: 221 / 255, green: 254 / 255, blue: 221 / 255, alpha: 1)

        privacyLabel.attributedText = getLinkFromText(text: privacyLabel.text!)
        privacyLabel.isUserInteractionEnabled = true
        userNameValidationLabel.isHidden = false
        userPasswordValidationLabel.isHidden = false

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
            checkLoginButtonState()
        } else {
            checkBoxButtonLabel.setImage(UIImage(systemName: "square"), for: .normal)
            checkLoginButtonState()
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

    func checkLoginButtonState() {
        if checkBoxButtonLabel.isSelected, userNameValidationLabel.isHidden, userPasswordValidationLabel.isHidden {
            loginButtonLabel.isEnabled = true
        } else {
            loginButtonLabel.isEnabled = false
        }
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let range = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: range, with: string)

        if textField == userNameTextField {
            validateUsername(updatedText)
        } else {
            validatePassword(updatedText)
        }

        if textField.isSecureTextEntry {
            textField.isSecureTextEntry = false
            textField.text?.replaceSubrange(range, with: string)
            textField.isSecureTextEntry = true
            return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }

    // MARK: - Validation methods

    func validateUsername(_ username: String) {

        if username.count < 6 {
            // Username must be at least 6 characters long
            userNameValidationLabel.isHidden = false
            checkLoginButtonState()
        } else {
            userNameValidationLabel.isHidden = true
            checkLoginButtonState()
        }
    }

    func validatePassword(_ password: String) {
        // Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        if !passwordPredicate.evaluate(with: password) {
            userPasswordValidationLabel.isHidden = false
            checkLoginButtonState()
        } else {
            userPasswordValidationLabel.isHidden = true
            checkLoginButtonState()
        }
    }
}
