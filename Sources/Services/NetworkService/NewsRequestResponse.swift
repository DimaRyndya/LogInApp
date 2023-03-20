import Foundation

struct NewsRequestResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case news = "results"
    }

    //MARK: - Properties

   var news: [NewsModel] = []
}
