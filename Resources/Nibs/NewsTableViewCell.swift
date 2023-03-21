import UIKit

final class NewsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var articleTextLabel: UILabel!

    // MARK: - Properties

    static let nibName = "NewsTableViewCell"
    static let identifier = "ArticleCell"

    // MARK: - Public

    func configure(with article: NewsModel) {
        articleTitleLabel.text = article.title
        articleTextLabel.text = article.description
    }

}
