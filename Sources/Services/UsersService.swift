import Foundation
import KeychainSwift

protocol UserServicing {
    func saveChache(userName: String, password: String)
    func getUserName() -> String
    func deleteCache()
}

final class UserService: UserServicing {

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
