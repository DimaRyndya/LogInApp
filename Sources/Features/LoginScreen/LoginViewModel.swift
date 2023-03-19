import Foundation

class LoginViewModel {

    let loginService: UserLoginService

    init(loginService: UserLoginService) {
        self.loginService = loginService
    }
}
