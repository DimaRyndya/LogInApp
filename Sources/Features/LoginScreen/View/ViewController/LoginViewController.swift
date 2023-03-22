import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties

    var viewModel: LoginViewModel!

    // MARK: - IBOutlets

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userPasswordTextField: UITextField!
    @IBOutlet private weak var checkBoxButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var privacyTextView: UITextView!
    @IBOutlet private weak var userNameValidationLabel: UILabel!
    @IBOutlet private weak var userPasswordValidationLabel: UILabel!

    // MARK: - Properties

    static let storybordIdentifier = "LoginStoryboard"
    static let identifier = "Login"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        let privacyText = viewModel.privacyPolicy

        privacyTextView.attributedText = getLinkFromText(
            text: privacyText.text,
            privacyText: privacyText.privacyText,
            url: privacyText.url)
        privacyTextView.delegate = self
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]

        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder ?? "", attributes: attributes)
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: userPasswordTextField.placeholder ?? "", attributes: attributes)
    }

    // MARK: - IBAction methods

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let userName = userNameTextField.text, let password = userPasswordTextField.text else { return }

        viewModel.loginButtonTapped(userName, password)
    }

    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        checkBoxButton.isSelected = !checkBoxButton.isSelected

        let imageName = checkBoxButton.isSelected ? "checkmark.square" : "square"

        checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
        updateLoginButtonState()
    }

    // MARK: - Helper methods

    private func getLinkFromText(text: String, privacyText: String, url: URL) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let privacyRange = (attributedString.string as NSString).range(of: privacyText)
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        attributedString.addAttributes(linkAttributes, range: privacyRange)
        attributedString.addAttribute(.link, value: url as Any, range: privacyRange)

        return attributedString
    }

    private func updateLoginButtonState() {
        guard let userName = userNameTextField.text, let password = userPasswordTextField.text else { return }

        let shouldEnableLoginButton = checkBoxButton.isSelected && userNameValidationLabel.isHidden && userPasswordValidationLabel.isHidden && !userName.isEmpty && !password.isEmpty
        
        loginButton.isEnabled = shouldEnableLoginButton
    }

    @objc private func handleTap() {
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
            if updatedText.isEmpty {
                userNameValidationLabel.isHidden = true
            } else {
                userNameValidationLabel.isHidden = viewModel.isUserNameValid(updatedText)
                updateLoginButtonState()
            }
        } else {
            if updatedText.isEmpty {
                userPasswordValidationLabel.isHidden = true
            } else {
                userPasswordValidationLabel.isHidden = viewModel.isPasswordValid(updatedText)
                updateLoginButtonState()
            }
        }

        /// ok for now
        if textField.isSecureTextEntry {
            textField.isSecureTextEntry = false
            textField.text?.replaceSubrange(range, with: string)
            textField.isSecureTextEntry = true
            return false
        } else {
            return true
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userNameValidationLabel.isHidden = true
            return true
        } else {
            userPasswordValidationLabel.isHidden = true
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userNameTextField.resignFirstResponder()
            return true
        } else {
            userPasswordTextField.resignFirstResponder()
            return true
        }
    }
}
