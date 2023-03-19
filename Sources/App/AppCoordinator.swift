import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private let rootVCBuilder: UIBuilderRootViewController
    private let loginService: UserLoginService

    // MARK: - Init

    init(window: UIWindow, rootVCBuilder: UIBuilderRootViewController, loginService: UserLoginService) {
        self.window = window
        self.rootVCBuilder = rootVCBuilder
        self.loginService = loginService
    }

    // MARK: - Public

    func startLoginFlow(animated: Bool) {
        let loginVC = rootVCBuilder.buildLoginViewController(loginService: loginService, coordinator: self)
        setRoot(viewController: loginVC, animated: animated)
    }

    func startMainFlow(animated: Bool) {
        let tabBarVC = rootVCBuilder.buildTabBarViewController(loginService: loginService, coordinator: self)
        setRoot(viewController: tabBarVC, animated: animated)
    }

    // TODO: Refactor animation

    private func setRoot(viewController: UIViewController, animated: Bool) {
        if animated {
            UIView.transition(with: window, duration: 0.5, options: [.transitionCurlDown], animations: {
                self.window.rootViewController = viewController
            }, completion: nil)
        } else {
            window.rootViewController = viewController
        }
    }
}
