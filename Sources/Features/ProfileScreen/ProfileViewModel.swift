import Foundation

class ProfileViewModel {
    
    let loginService: UserLoginService
    weak var appCoordinator: AppCoordinator?

    init(loginService: UserLoginService, appCoordinator: AppCoordinator?) {
        self.loginService = loginService
        self.appCoordinator = appCoordinator
    }

    func logoutButtonTapped() {
        appCoordinator?.startLoginFlow(animated: true)
    }
}
