import Foundation
import Realm
import RealmSwift

protocol NewsStorage {
    func save(_ models: [Article])
    func read() -> [Article]
}

struct NewsStorageImpl: NewsStorage {
    
    func save(_ models: [Article]) {
        let newArticles = models.map { DBArticle(article: $0) }
        
        do {
            let realm = try Realm()
            let oldArticles = realm.objects(DBArticle.self)
            
            try realm.write {
                realm.delete(oldArticles)
                realm.add(newArticles)
            }
        } catch {
            print(error)
        }
    }
    
    func read() -> [Article] {
        var companies: [Article] = []
        
        do {
            let realm = try Realm()
            companies = realm.objects(DBArticle.self).compactMap { $0.article() }
        } catch {
            print(error)
        }
        
        return companies
    }
    
}
