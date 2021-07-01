import Foundation
import Realm
import RealmSwift

protocol ViewedNewsStorage {
    func save(_ models: [ViewedArticle])
    func read() -> [ViewedArticle]
}

struct ViewedNewsStorageImpl: ViewedNewsStorage {
    
    func save(_ models: [ViewedArticle]) {
        let newArticles = models.map { DBViewedArticle(viewedArticle: $0) }
        
        do {
            let realm = try Realm()
            let oldArticles = realm.objects(DBViewedArticle.self)
            
            try realm.write {
                realm.delete(oldArticles)
                realm.add(newArticles)
            }
        } catch {
            print(error)
        }
    }
    
    func read() -> [ViewedArticle] {
        var companies: [ViewedArticle] = []
        
        do {
            let realm = try Realm()
            companies = realm.objects(DBViewedArticle.self).compactMap { $0.viewedArticle() }
        } catch {
            print(error)
        }
        
        return companies
    }
    
}
