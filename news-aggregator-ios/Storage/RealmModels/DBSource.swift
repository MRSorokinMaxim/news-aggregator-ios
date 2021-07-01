import Foundation
import Realm
import RealmSwift

final class DBSource: Object {
    
    // MARK: - Public Properties

    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var descriptionText: String?
    @objc dynamic var url: String?
    @objc dynamic var category: DBCategory?
    @objc dynamic var language: DBLanguage?
    @objc dynamic var country: DBCountry?

    // MARK: - Init
    
    required override init() {}
    
    init(source: Source) {
        super.init()
        
        self.id = source.id
        self.name = source.name
        self.descriptionText = source.description
        self.url = source.url
        
        if let category = source.category {
            self.category = DBCategory(category: category)
        }
        
        if let language = source.language {
            self.language = DBLanguage(language: language)
        }
        
        if let country = source.country {
            self.country = DBCountry(country: country)
        }
    }
    
    
    func getSource() -> Source? {
        return Source(id: id ?? "",
                      name: name ?? "",
                      description: descriptionText ?? "",
                      url: url ?? "",
                      category: category?.getCategory(),
                      language: language?.getLanguage(),
                      country: country?.getCountry())
    }
}
