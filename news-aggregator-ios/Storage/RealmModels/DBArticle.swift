import Foundation
import Realm
import RealmSwift

final class DBArticle: Object {
    
    // MARK: - Public Properties

    @objc dynamic var articleSource: DBArticleSource?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var descriptionText: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?

    // MARK: - Init
    
    required override init() {}
    
    init(article: Article) {
        super.init()
        
        if let source = article.source {
            self.articleSource = DBArticleSource(articleSource: source)
        }
        self.author = article.author
        self.title = article.title
        self.descriptionText = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
    
    func article() -> Article? {
        return Article(source: articleSource?.articleSource(),
                       author: author,
                       title: title,
                       description: descriptionText,
                       url: url,
                       urlToImage: urlToImage,
                       publishedAt: publishedAt,
                       content: content)
    }
}
