import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties

    var viewModel: LoginViewModel!

    // MARK: - IBOutlets

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userPasswordTextField: UITextField!
    @IBOutlet private weak var checkBoxButtonLabel: UIButton!
    @IBOutlet private weak var loginButtonLabel: UIButton!
    @IBOutlet private weak var privacyLabel: UITextView!
    @IBOutlet private weak var userNameValidationLabel: UILabel!
    @IBOutlet private weak var userPasswordValidationLabel: UILabel!

    // MARK: - Properties

    static let storybordIdentifier = "LoginStoryboard"

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
        checkBoxButtonLabel.isSelected = false
        loginButtonLabel.isEnabled = false

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]

        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: attributes)
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: userPasswordTextField.placeholder!, attributes: attributes)

        privacyLabel.delegate = self
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self


    }

    // MARK: - IBAction methods

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let userName = userNameTextField.text, let password = userPasswordTextField.text else { return }
        
        viewModel.saveUserAccount(userName: userName, password: password)
        viewModel.loginButtonTapped()
    }

    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        checkBoxButtonLabel.isSelected = !checkBoxButtonLabel.isSelected

        let imageName = checkBoxButtonLabel.isSelected ? "checkmark.square" : "square"

        checkBoxButtonLabel.setImage(UIImage(systemName: imageName), for: .normal)
        checkLoginButtonState()
    }

    // MARK: - Helper methods

    private func getLinkFromText(text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let privacyRange = (attributedString.string as NSString).range(of: "Privacy Policy")
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]
        attributedString.addAttributes(linkAttributes, range: privacyRange)
        let url = URL(string: "https://redwing-studio.com/")
        attributedString.addAttribute(.link, value: url as Any, range: privacyRange)

        privacyLabel.attributedText = attributedString

        return attributedString
    }

    private func checkLoginButtonState() {
        let shouldEnableLoginButton = checkBoxButtonLabel.isSelected && userNameValidationLabel.isHidden && userPasswordValidationLabel.isHidden
        loginButtonLabel.isEnabled = shouldEnableLoginButton
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

        textField == userNameTextField ? validateUsername(updatedText) : validatePassword(updatedText)

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
        let shouldHideHint = username.count >= 6
        
        userNameValidationLabel.isHidden = shouldHideHint
        checkLoginButtonState()
    }

    func validatePassword(_ password: String) {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let shouldHidePasswordHint = passwordPredicate.evaluate(with: password)

        userPasswordValidationLabel.isHidden = shouldHidePasswordHint
        checkLoginButtonState()
    }
}
