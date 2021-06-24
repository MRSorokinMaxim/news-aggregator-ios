import Foundation
import Realm
import RealmSwift

final class DBLanguage: Object {
 
    @objc dynamic var language: String?
    
    // MARK: - Init
    
    required override init() {}
    
    init(language: Language) {
        super.init()
        
        self.language = language.rawValue
    }
    
    
    func getLanguage() -> Language? {
        guard let language = language else {
            return nil
        }
        
        return Language(rawValue: language)
    }
}
