import Foundation
import Realm
import RealmSwift

protocol SourceStorage {
    func save(_ models: [Source])
    func read() -> [Source]
}

struct SourceStorageImpl: SourceStorage {
    
    func save(_ models: [Source]) {
        let newSource = models.map { DBSource(source: $0) }
        
        do {
            let realm = try Realm()
            let oldSource = realm.objects(DBSource.self)
            
            try realm.write {
                realm.delete(oldSource)
                realm.add(newSource)
            }
        } catch {
            print(error)
        }
    }
    
    func read() -> [Source] {
        var companies: [Source] = []
        
        do {
            let realm = try Realm()
            companies = realm.objects(DBSource.self).compactMap { $0.getSource() }
        } catch {
            print(error)
        }
        
        return companies
    }
    
}
