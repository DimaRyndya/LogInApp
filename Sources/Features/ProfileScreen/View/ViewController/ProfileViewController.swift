import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var userNameLabel: UILabel!
    
    // MARK: - Properties
    
    static let storybordIdentifier = "ProfileStoryboard"
    static let identifier = "Profile"
    
    var viewModel: ProfileViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = viewModel.viewLoaded()
    }
    
    // MARK: - IBAction methods
    
    @IBAction func logOutDidTapped(_ sender: Any) {
        viewModel.logOutButtonTapped()
    }
}
