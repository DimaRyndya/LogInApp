import Foundation

final class ProfileViewModel {

    // MARK: - Properties
    
    private let loginService: UserServicing
    private weak var appCoordinator: AppCoordinator?

    // MARK: - Init

    init(loginService: UserServicing, appCoordinator: AppCoordinator?) {
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
