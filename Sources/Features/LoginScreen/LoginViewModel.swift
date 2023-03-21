import UIKit

final class LoginViewModel {

    // MARK: - Properties

    private let loginService: UserServicing
    private weak var appCoordinator: AppCoordinator?

    // MARK: - Init

    init(loginService: UserServicing, appCoordinator: AppCoordinator?) {
        self.loginService = loginService
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func loginButtonTapped(save username: String, and password: String) {
        appCoordinator?.startMainFlow(animated: true)
        saveUserAccount(userName: username, password: password)
    }

    func saveUserAccount(userName: String, password: String) {
        loginService.saveChache(userName: userName, password: password)
    }

    // MARK: - Validation methods

    func isUserNameValid(_ username: String) -> Bool {
        let shouldHideHint = username.count >= 6

        return shouldHideHint
    }

    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let shouldHidePasswordHint = passwordPredicate.evaluate(with: password)

        return shouldHidePasswordHint
    }
}
