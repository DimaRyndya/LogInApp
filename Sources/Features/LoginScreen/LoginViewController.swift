import UIKit

class LoginViewController: UIViewController {

    var viewModel: LoginViewModel!

    // MARK: - IBOutlets

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var checkBoxButtonLabel: UIButton!
    @IBOutlet weak var loginButtonLabel: UIButton!
    @IBOutlet weak var privacyLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        privacyLabel.attributedText = getLinkFromText(text: privacyLabel.text!)
        privacyLabel.isUserInteractionEnabled = true

        checkBoxButtonLabel.isSelected = false
        loginButtonLabel.isEnabled = false
    }

    // MARK: - IBAction methods

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let userName = userNameTextField.text, let password = userPasswordTextField.text else { return }
        
        viewModel.loginService.save(userName: userName, password: password)

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let tabBarVC = sceneDelegate.rootVCBuilder.buildTabBarViewController(loginService: viewModel.loginService)
            UIView.transition(with: sceneDelegate.window ?? UIWindow(), duration: 0.5, options: [.transitionCrossDissolve], animations: {
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
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]
        attributedString.addAttributes(linkAttributes, range: privacyRange)
        let url = URL(string: "https://redwing-studio.com/")
        attributedString.addAttribute(.link, value: url as Any, range: privacyRange)

        // Add tap gesture recognizer to label
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        privacyLabel.addGestureRecognizer(tapGestureRecognizer)
        privacyLabel.isUserInteractionEnabled = true

        // Store the range in a custom property of the tap gesture recognizer
        tapGestureRecognizer.privacyRange = privacyRange

        return attributedString
    }

    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let attributedString = privacyLabel.attributedText else { return }

        let tapLocation = sender.location(in: privacyLabel)

        // Get the bounding rectangle of the text
        let textBoundingBox = attributedString.boundingRect(with: privacyLabel.bounds.size, options: .usesLineFragmentOrigin, context: nil)

        // Create a text container and layout manager for the attributed string
        let textContainer = NSTextContainer(size: privacyLabel.bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        let textStorage = NSTextStorage(attributedString: attributedString)
        textStorage.addLayoutManager(layoutManager)

        // Find the character index of the tap location
        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // Check if the tap was within the privacy range
        if (attributedString.string as NSString).range(of: "Privacy Policy").contains(characterIndex) {
            if let url = URL(string: "https://redwing-studio.com/") {
                UIApplication.shared.open(url)
            }
        }
    }
}
