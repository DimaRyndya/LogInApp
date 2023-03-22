import UIKit

final class UIBuilder {
    
    // MARK: - Public
    
    func buildTabBarViewController(usersService: UserServicing, coordinator: AppCoordinator) -> UITabBarController {
        
        // MARK: - Set up News Screen
        
        let newsViewController = UIStoryboard(name: NewsTableViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: NewsTableViewController.identifier) as? NewsTableViewController
        let newsURL = "/svc/mostpopular/v2/emailed/30.json"
        let newsNetworkService = NewsNetworkService(requestURL: newsURL)
        let newsViewModel = NewsViewModel(networkService: newsNetworkService)
        
        newsViewModel.delegate = newsViewController
        newsViewController?.viewModel = newsViewModel
        
        // MARK: - Set up Profile Screen
        
        let profileViewController = UIStoryboard(name: ProfileViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: ProfileViewController.identifier) as? ProfileViewController
        let profileViewModel = ProfileViewModel(usersService: usersService, appCoordinator: coordinator)
        
        profileViewController?.viewModel = profileViewModel
        
        // MARK: - Set up TabBar
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([newsViewController ?? UIViewController(), profileViewController ?? UIViewController()], animated: false)
        
        if let newsItem = tabBarController.tabBar.items?[0] {
            newsItem.title = "Popular News"
            newsItem.image = UIImage(systemName: "envelope.circle")
            newsItem.selectedImage = UIImage(systemName: "envelope.circle.fill")
        }
        
        if let profileItem = tabBarController.tabBar.items?[1] {
            profileItem.title = "Profile"
            profileItem.image = UIImage(systemName: "person.circle")
            profileItem.selectedImage = UIImage(systemName: "person.circle.fill")
        }
        
        return tabBarController
    }
    
    // MARK: - Set up Login Screen
    
    func buildLoginViewController(usersService: UserServicing, coordinator: AppCoordinator) -> LoginViewController {
        let loginViewController = UIStoryboard(name: LoginViewController.storybordIdentifier, bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
        let loginViewModel = LoginViewModel(usersService: usersService, appCoordinator: coordinator)
        
        loginViewController.viewModel = loginViewModel
        
        return loginViewController
    }
}
