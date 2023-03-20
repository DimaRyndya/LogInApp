import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var logOutButtonLabel: UIButton!

    // MARK: - Properties

    static let storybordIdentifier = "ProfileStoryboard"
    static let identifier = "Profile"

    var viewModel: ProfileViewModel!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 221 / 255, green: 254 / 255, blue: 221 / 255, alpha: 1)
        userNameLabel.text = viewModel.viewLoaded()
    }

    // MARK: - IBAction methods

    @IBAction func logOutDidTapped(_ sender: Any) {
        viewModel.logOutButtonTapped()
    }
}
