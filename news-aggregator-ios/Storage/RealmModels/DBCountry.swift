import Foundation
import Realm
import RealmSwift

final class DBCountry: Object {
 
    @objc dynamic var country: String?
    
    // MARK: - Init
    
    required override init() {}
    
    init(country: Country) {
        super.init()
        
        self.country = country.rawValue
    }
    
    
    func getCountry() -> Country? {
        guard let country = country else {
            return nil
        }
        
        return Country(rawValue: country)
    }
}
