import UIKit

// MARK: - Helper Types

private enum LoadingCellConstants {
    static let nibName = "LoadingTableViewCell"
    static let identifier = "LoadingCell"
    static let spinnerTag = 100
}

final class ArticlesTableViewController: UITableViewController {

    //MARK: - Properties

    var viewModel: ArticlesViewModel!

    static let storybordIdentifier = "ArticlesStoryboard"
    static let tableViewRowHeight = 44.0

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: ArticleTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        nib = UINib(nibName: LoadingCellConstants.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: LoadingCellConstants.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = ArticlesTableViewController.tableViewRowHeight

        viewModel.delegate = self
        viewModel.loadArticles()
        viewModel.state = .loading
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

//MARK: - MostEmailed ViewModel Delegate

extension ArticlesTableViewController: ArticlesViewModelDelegate {
    func reloadUI(_ viewModel: ArticlesViewModel) {
        viewModel.state = .foundArticles
        tableView.reloadData()
    }
}


// MARK: - Table view data source

extension ArticlesTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .loading:
            return 1
        case .foundArticles:
            return viewModel.articles.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCellConstants.identifier, for: indexPath)
            let spinner = cell.viewWithTag(LoadingCellConstants.spinnerTag) as! UIActivityIndicatorView

            spinner.startAnimating()

            tableView.separatorStyle = .none
            return cell

        case .foundArticles:
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
            let article = viewModel.articles[indexPath.row]

            tableView.separatorStyle = .singleLine

            cell.configure(with: article)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
