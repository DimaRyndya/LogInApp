import UIKit

protocol ArticlesViewModelDelegate: AnyObject {
    func reloadUI(_ viewModel: ArticlesViewModel)
}

final class ArticlesViewModel {

    enum State {
        case loading
        case foundArticles
    }

    //MARK: - Properties

    var state: State = .loading
    var articles: [ArticleModel] = []

    private let networkService: ArticlesNetworkService

    weak var delegate: ArticlesViewModelDelegate?

    //MARK: - Init

    init(networkService: ArticlesNetworkService) {
        self.networkService = networkService
    }

    func loadArticles() {
        networkService.fetchArticles { [weak self] response in
            guard let self else { return }
            self.articles = response
            self.delegate?.reloadUI(self)
        }
    }
}
