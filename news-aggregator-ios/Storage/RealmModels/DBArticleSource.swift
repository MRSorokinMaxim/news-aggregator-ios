import Foundation
import Realm
import RealmSwift

final class DBArticleSource: Object {
 
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    
    // MARK: - Init
    
    required override init() {}
    
    init(articleSource: ArticleSource) {
        super.init()
        
        id = articleSource.id
        name = articleSource.name
    }
    
    
    func articleSource() -> ArticleSource? {
        ArticleSource(id: id, name: name)
    }
}
