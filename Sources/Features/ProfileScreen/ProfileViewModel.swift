import Foundation

final class ProfileViewModel {

    // MARK: - Properties
    
    private let loginService: UserLoginService
    private weak var appCoordinator: AppCoordinator?

    // MARK: - Init

    init(loginService: UserLoginService, appCoordinator: AppCoordinator?) {
        self.loginService = loginService
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func logOutButtonTapped() {
        appCoordinator?.startLoginFlow(animated: true)
        loginService.deleteCache()
    }

    func viewLoaded() -> String{
        loginService.getUserName()
    }
    
}
