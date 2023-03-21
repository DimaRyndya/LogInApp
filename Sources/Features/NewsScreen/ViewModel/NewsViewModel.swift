import Foundation

protocol NewsViewModelDelegate: AnyObject {
    func reloadUI()
    func showAlert()
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

            switch response {
            case .success(let result):
                self.news = result
                self.state = .foundNews
                self.delegate?.reloadUI()

            case .failure(_):
                self.delegate?.showAlert()
            }
        }
    }

    func getNumberOfSections() -> Int {
        switch state {
        case .loading:
            return 1
        case .foundNews:
            return news.count
        }
    }
}
