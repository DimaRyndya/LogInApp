import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var appCoordinator: AppCoordinator?

    // MARK: - Application lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootVCBuilder = UIBuilderRootViewController()
        let loginService = UserLoginService()

        appCoordinator = AppCoordinator(window: window, rootVCBuilder: rootVCBuilder, loginService: loginService)

        if loginService.isUserLoggedIn {
            appCoordinator?.startMainFlow(animated: false)
        } else {
            appCoordinator?.startLoginFlow(animated: false)
        }

        window.makeKeyAndVisible()
    }
}
