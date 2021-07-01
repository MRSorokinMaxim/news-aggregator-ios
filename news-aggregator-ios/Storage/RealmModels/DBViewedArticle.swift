import Foundation
import Realm
import RealmSwift

struct ViewedArticle {
    let title: String
    let isOpen: Bool
}

final class DBViewedArticle: Object {
    
    // MARK: - Public Properties

    @objc dynamic var title: String?
    @objc dynamic var isOpen: String?

    // MARK: - Init
    
    required override init() {}
    
    init(viewedArticle: ViewedArticle) {
        super.init()
        
        self.title = viewedArticle.title
        self.isOpen = viewedArticle.isOpen ? "1" : "0"
    }
    
    func viewedArticle() -> ViewedArticle? {
        return ViewedArticle(title: title ?? "", isOpen: isOpen == "1")
    }
}
