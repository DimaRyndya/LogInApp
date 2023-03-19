import UIKit

final class UIBuilderRootViewController {

//    let navigationController = UIStoryboard(name: ArticlesTableViewController.storybordIdentifier, bundle: nil).instantiateInitialViewController() as? UINavigationController

    // MARK: - Public

    func buildTabBarViewController(loginService: UserLoginService) -> UITabBarController {

        // MARK: - Set up News Screen

        let newsVC = UIStoryboard(name: ArticlesTableViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: "ArticlesTableView") as? ArticlesTableViewController
        let newsURL = "/svc/mostpopular/v2/emailed/30.json"
        let newsNetworkService = ArticlesNetworkService(requestURL: newsURL)
        let newsViewModel = ArticlesViewModel(networkService: newsNetworkService)

        newsVC?.viewModel = newsViewModel

        // MARK: - Set up Profile Screen

        let profileVC = UIStoryboard(name: ProfileViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: "Profile") as? ProfileViewController
        let profileViewModel = ProfileViewModel(loginService: loginService)

        profileVC?.viewModel = profileViewModel

        // MARK: - Set up TabBar

        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([newsVC ?? UIViewController(), profileVC ?? UIViewController()], animated: false)

        if let newsItem = tabBarVC.tabBar.items?[0] {
            newsItem.title = "News"
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

    func buildLoginViewController(loginService: UserLoginService) -> LoginViewController {
//        navigationController?.navigationBar.isHidden = true
//        let loginVC = navigationController?.viewControllers.first as? LoginViewController
        let loginVC = UIStoryboard(name: ArticlesTableViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        let loginViewModel = LoginViewModel(loginService: loginService)

        loginVC.viewModel = loginViewModel

        return loginVC
    }
}
