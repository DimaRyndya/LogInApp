import UIKit
import Alamofire

protocol NewsNetwork {
    func fetchNews(completion: @escaping (Result<[NewsModel], Error>) -> ())
}

final class NewsNetworkService: NewsNetwork {
    
    // MARK: - Properties
    
    private let baseURL = "https://api.nytimes.com"
    private let requestURL: String
    private let parameters: Parameters = ["api-key" : "i4T2FJirMgYdE6aDvr5oBugtyBtqJff0"]
    
    // MARK: - Init
    
    init(requestURL: String) {
        self.requestURL = requestURL
    }
    
    // MARK: - Fetch Request
    
    func fetchNews(completion: @escaping (Result<[NewsModel], Error>) -> ()) {
        AF.request(baseURL + requestURL, parameters: parameters).responseDecodable(of: NewsRequestResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result.news) )
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}
