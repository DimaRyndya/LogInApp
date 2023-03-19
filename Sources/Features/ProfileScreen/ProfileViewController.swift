import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logOutButtonLabel: UIButton!

    static let storybordIdentifier = "ProfileStoryboard"

    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = viewModel.loginService.getUserName()
    }

    @IBAction func logOutDidTapped(_ sender: Any) {
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let loginVC = sceneDelegate.rootVCBuilder.navigationController?.viewControllers.first as? LoginViewController, let navController = sceneDelegate.rootVCBuilder.navigationController {
//
////            loginVC.userNameTextField.text = nil
////            loginVC.userPasswordTextField.text = nil
////            loginVC.checkBoxButtonLabel.isSelected = false
////            loginVC.loginButtonLabel.isEnabled = false
////            loginVC.checkBoxButtonLabel.setImage(UIImage(systemName: "square"), for: .normal)
//
//            sceneDelegate.window?.rootViewController = navController
//
//            navController.popToViewController(loginVC, animated: true)
//        }

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginVC = sceneDelegate.rootVCBuilder.buildLoginViewController(loginService: viewModel.loginService)
            UIView.transition(with: sceneDelegate.window ?? UIWindow(), duration: 0.5, options: [.transitionCurlDown], animations: {
                sceneDelegate.window?.rootViewController = loginVC
            }, completion: nil)
        }

        viewModel.loginService.deleteCache()
    }

}

