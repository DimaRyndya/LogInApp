import UIKit

final class ArticleTableViewCell: UITableViewCell {

    //MARK: - Outlets

    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleTextLabel: UILabel!

    static let nibName = "ArticleTableViewCell"
    static let identifier = "ArticleCell"

    //MARK: - Public

    func configure(with article: ArticleModel) {
        articleTitleLabel.text = article.title
        articleTextLabel.text = article.description
    }

}
