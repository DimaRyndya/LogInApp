import UIKit

protocol NewsViewModelDelegate: AnyObject {
    func reloadUI(_ viewModel: NewsViewModel)
}

final class NewsViewModel {

    enum State {
        case loading
        case foundArticles
    }

    // MARK: - Properties

    var state: State = .loading
    var articles: [NewsModel] = []

    private let networkService: ArticlesNetworkService

    weak var delegate: NewsViewModelDelegate?

    // MARK: - Init

    init(networkService: ArticlesNetworkService) {
        self.networkService = networkService
    }

    // MARK: - Public

    func loadArticles() {
        networkService.fetchArticles { [weak self] response in
            guard let self else { return }
            self.articles = response
            self.delegate?.reloadUI(self)
        }
    }
}
