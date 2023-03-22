import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    private var appCoordinator: AppCoordinator?
    
    // MARK: - Application lifecycle
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        initAppCoordinator(with: window)
        
        window.makeKeyAndVisible()
    }
    
    // MARK: - AppCoordinator Init method
    
    private func initAppCoordinator(with window: UIWindow) {
        let rootVCBuilder = UIBuilder()
        let usersService: UserServicing = UserService()
        
        appCoordinator = AppCoordinator(window: window, rootVCBuilder: rootVCBuilder, usersService: usersService)
        
        if usersService.isUserLoggedIn {
            appCoordinator?.startMainFlow(animated: false)
        } else {
            appCoordinator?.startLoginFlow(animated: false)
        }
    }
}
