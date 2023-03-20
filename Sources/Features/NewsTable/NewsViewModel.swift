import UIKit

protocol NewsViewModelDelegate: AnyObject {
    func reloadUI(_ viewModel: NewsViewModel)
}

final class NewsViewModel {

    enum State {
        case loading
        case foundNews
    }

    // MARK: - Properties

    private(set) var state: State = .loading
    var news: [NewsModel] = []

    private let networkService: NewsNetwork

    weak var delegate: NewsViewModelDelegate?

    // MARK: - Init

    init(networkService: NewsNetwork) {
        self.networkService = networkService
    }

    // MARK: - Public

    func viewDidFinishLoading() {
        loadNews()
        state = .loading
    }

    func loadNews() {
        networkService.fetchNews { [weak self] response in
            guard let self else { return }
            self.news = response
            self.state = .foundNews
            self.delegate?.reloadUI(self)
        }
    }

    func setNumberOfSections() -> Int {
        switch state {
        case .loading:
            return 1
        case .foundNews:
            return news.count
        }
    }
}
