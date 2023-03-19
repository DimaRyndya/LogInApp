final class ArticleModel {

    let title: String
    let description: String

    //MARK: - Init

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

//MARK: - Helper Types

extension ArticleModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case title
        case description = "abstract"
    }
}
