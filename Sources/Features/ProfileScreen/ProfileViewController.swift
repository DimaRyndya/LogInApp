import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logOutButtonLabel: UIButton!

    static let storybordIdentifier = "ProfileStoryboard"

    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 221 / 255, green: 254 / 255, blue: 221 / 255, alpha: 1)
        userNameLabel.text = viewModel.loginService.getUserName()
    }

    @IBAction func logOutDidTapped(_ sender: Any) {

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginVC = sceneDelegate.rootVCBuilder.buildLoginViewController(loginService: viewModel.loginService)
            UIView.transition(with: sceneDelegate.window ?? UIWindow(), duration: 0.5, options: [.transitionCurlDown], animations: {
                sceneDelegate.window?.rootViewController = loginVC
            }, completion: nil)
        }

        viewModel.loginService.deleteCache()
    }

}

