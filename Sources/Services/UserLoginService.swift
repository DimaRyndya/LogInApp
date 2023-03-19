import Foundation
import KeychainSwift

final class UserLoginService {

    // MARK: - Properties

    private let keyChain = KeychainSwift()

    var isUserLoggedIn: Bool {
        keyChain.getBool("isLoggedIn") ?? false
    }

    // MARK: - Public

    func saveChache(userName: String, password: String) {
        keyChain.set(userName, forKey: "username")
        keyChain.set(password, forKey: "password")
        keyChain.set(true, forKey: "isLoggedIn")
    }

    func getUserName() -> String {
        let userName = keyChain.get("username") ?? ""
        return userName
    }

    func deleteCache() {
        keyChain.delete("isLoggedIn")
        keyChain.delete("username")
        keyChain.delete("password")
    }
}
