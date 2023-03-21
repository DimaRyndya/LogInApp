import Foundation

final class ProfileViewModel {

    // MARK: - Properties
    
    private let usersService: UserServicing
    private weak var appCoordinator: AppCoordinator?

    // MARK: - Init

    init(usersService: UserServicing, appCoordinator: AppCoordinator?) {
        self.usersService = usersService
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func logOutButtonTapped() {
        appCoordinator?.startLoginFlow(animated: true)
        usersService.deleteCache()
    }

    func viewLoaded() -> String{
        usersService.getUserName()
    }
    
}
