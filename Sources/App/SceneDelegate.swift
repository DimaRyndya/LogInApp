import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?
    let rootVCBuilder = UIBuilderRootViewController()
    let loginService = UserLoginService()

    // MARK: - Application lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        if loginService.isUserLoggedIn {
            let tabBarVC = rootVCBuilder.buildTabBarViewController(loginService: loginService)
            window.rootViewController = tabBarVC
        } else {
            let loginVC = rootVCBuilder.buildLoginViewController(loginService: loginService)
            window.rootViewController = loginVC
        }
        self.window = window
        window.makeKeyAndVisible()
    }
}
