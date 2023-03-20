import UIKit
import Alamofire

protocol NewsNetwork {
    func fetchNews(completion: @escaping ([NewsModel]) -> ())
}

final class NewsNetworkService: NewsNetwork {

    //MARK: - Properties

    private let baseURL = "https://api.nytimes.com"
    private let requestURL: String
    private let parameters: Parameters = ["api-key" : "i4T2FJirMgYdE6aDvr5oBugtyBtqJff0"]

    //MARK: Init

    init(requestURL: String) {
        self.requestURL = requestURL
    }

    //MARK: - Public

    func fetchNews(completion: @escaping ([NewsModel]) -> ()) {
        AF.request(baseURL + requestURL, parameters: parameters).responseDecodable(of: NewsRequestResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(result.news)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
