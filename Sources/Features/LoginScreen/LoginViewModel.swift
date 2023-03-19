import Foundation

final class LoginViewModel {

    // MARK: - Properties

    private let loginService: UserLoginService
    private weak var appCoordinator: AppCoordinator?

    // MARK: - Init

    init(loginService: UserLoginService, appCoordinator: AppCoordinator?) {
        self.loginService = loginService
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func loginButtonTapped() {
        appCoordinator?.startMainFlow(animated: true)
    }

    func saveUserAccount(userName: String, password: String) {
        loginService.saveChache(userName: userName, password: password)
    }
}
