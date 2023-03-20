import UIKit

// MARK: - Helper Types

private enum LoadingCellConstants {
    static let nibName = "LoadingTableViewCell"
    static let identifier = "LoadingCell"
    static let spinnerTag = 100
}

final class NewsTableViewController: UITableViewController {

    // MARK: - Properties

    var viewModel: NewsViewModel!

    static let storybordIdentifier = "NewsStoryboard"
    static let identifier = "NewsTableView"
    static let tableViewRowHeight = 44.0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: NewsTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
        nib = UINib(nibName: LoadingCellConstants.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: LoadingCellConstants.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = NewsTableViewController.tableViewRowHeight

        viewModel.viewDidFinishLoading()
    }
}

// MARK: - News ViewModel Delegate

extension NewsTableViewController: NewsViewModelDelegate {
    func reloadUI(_ viewModel: NewsViewModel) {
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension NewsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfSections()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCellConstants.identifier, for: indexPath)
            let spinner = cell.viewWithTag(LoadingCellConstants.spinnerTag) as! UIActivityIndicatorView

            spinner.startAnimating()

            tableView.separatorStyle = .none
            return cell

        case .foundNews:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
            let article = viewModel.news[indexPath.row]

            tableView.separatorStyle = .singleLine

            cell.configure(with: article)
            return cell
        }
    }
}

// MARK: - Table view delegate methods

extension NewsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
