import Foundation

struct ArticleRequestResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case articles = "results"
    }

    //MARK: - Properties

   var articles: [NewsModel] = []
}
