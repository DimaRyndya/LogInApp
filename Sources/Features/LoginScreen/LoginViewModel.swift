import Foundation

class LoginViewModel {

    let loginService: UserLoginService
    weak var appCoordinator: AppCoordinator?

    init(loginService: UserLoginService, appCoordinator: AppCoordinator?) {
        self.loginService = loginService
        self.appCoordinator = appCoordinator
    }

    func loginButtonTapped() {
        appCoordinator?.startMainFlow(animated: true)
    }
}
