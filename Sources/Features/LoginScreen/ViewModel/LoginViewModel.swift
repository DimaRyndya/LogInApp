import UIKit

final class LoginViewModel {
    
    // MARK: - Properties
    
    private let usersService: UserServicing
    private weak var appCoordinator: AppCoordinator?
    
    var privacyPolicy: (text: String, privacyText: String, url: URL) {
        ("By registering, you agree to the Privacy Policy",
         "Privacy Policy",
         URL(string: "https://redwing-studio.com/") ?? URL(fileReferenceLiteralResourceName: ""))
    }
    
    // MARK: - Init
    
    init(usersService: UserServicing, appCoordinator: AppCoordinator?) {
        self.usersService = usersService
        self.appCoordinator = appCoordinator
    }
    
    // MARK: - Public
    
    func loginButtonTapped(_ username: String, _ password: String) {
        appCoordinator?.startMainFlow(animated: true)
        saveUserAccount(userName: username, password: password)
    }
    
    func saveUserAccount(userName: String, password: String) {
        usersService.saveCache(userName: userName, password: password)
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
