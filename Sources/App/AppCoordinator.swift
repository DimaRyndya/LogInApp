import UIKit

final class AppCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    private let rootVCBuilder: UIBuilder
    private let usersService: UserServicing
    
    // MARK: - Init
    
    init(window: UIWindow, rootVCBuilder: UIBuilder, usersService: UserServicing) {
        self.window = window
        self.rootVCBuilder = rootVCBuilder
        self.usersService = usersService
    }
    
    // MARK: - Public
    
    func startLoginFlow(animated: Bool) {
        let loginVC = rootVCBuilder.buildLoginViewController(usersService: usersService, coordinator: self)
        setRoot(viewController: loginVC, animated: animated)
    }
    
    func startMainFlow(animated: Bool) {
        let tabBarVC = rootVCBuilder.buildTabBarViewController(usersService: usersService, coordinator: self)
        setRoot(viewController: tabBarVC, animated: animated)
    }
    
    // MARK: - Private
    
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
