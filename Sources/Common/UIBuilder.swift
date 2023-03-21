import UIKit

final class UIBuilder {

    // MARK: - Public

    func buildTabBarViewController(usersService: UserServicing, coordinator: AppCoordinator) -> UITabBarController {

        // MARK: - Set up News Screen

        let newsVC = UIStoryboard(name: NewsTableViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: NewsTableViewController.identifier) as? NewsTableViewController
        let newsURL = "/svc/mostpopular/v2/emailed/30.json"
        let newsNetworkService = NewsNetworkService(requestURL: newsURL)
        let newsViewModel = NewsViewModel(networkService: newsNetworkService)

        newsVC?.viewModel = newsViewModel
        newsVC?.viewModel.delegate = newsVC

        // MARK: - Set up Profile Screen

        let profileVC = UIStoryboard(name: ProfileViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: ProfileViewController.identifier) as? ProfileViewController
        let profileViewModel = ProfileViewModel(usersService: usersService, appCoordinator: coordinator)

        profileVC?.viewModel = profileViewModel

        // MARK: - Set up TabBar

        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([newsVC ?? UIViewController(), profileVC ?? UIViewController()], animated: false)

        if let newsItem = tabBarVC.tabBar.items?[0] {
            newsItem.title = "Popular News"
            newsItem.image = UIImage(systemName: "envelope.circle")
            newsItem.selectedImage = UIImage(systemName: "envelope.circle.fill")
        }

        if let profileItem = tabBarVC.tabBar.items?[1] {
            profileItem.title = "Profile"
            profileItem.image = UIImage(systemName: "person.circle")
            profileItem.selectedImage = UIImage(systemName: "person.circle.fill")
        }

        return tabBarVC
    }

    // MARK: - Set up Login Screen

    func buildLoginViewController(usersService: UserServicing, coordinator: AppCoordinator) -> LoginViewController? {
        let loginVC = UIStoryboard(name: LoginViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identifier) as? LoginViewController
        let loginViewModel = LoginViewModel(usersService: usersService, appCoordinator: coordinator)

        loginVC?.viewModel = loginViewModel

        return loginVC ?? LoginViewController()
    }
}
