import Foundation
import Realm
import RealmSwift

final class DBCategory: Object {
 
    @objc dynamic var category: String?
    
    // MARK: - Init
    
    required override init() {}
    
    init(category: Category) {
        super.init()
        
        self.category = category.rawValue
    }
    
    
    func getCategory() -> Category? {
        guard let category = category else {
            return nil
        }
        
        return Category(rawValue: category)
    }
}
