import Foundation

struct SourcesRequest: Codable {
    let category: Category?
    let language: Language?
    let country: Country?
    
    private enum CodingKeys: String, CodingKey {
        case category
        case language
        case country
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        if let category = self.category {
            try container.encode(category, forKey: .category)
        }
        
        if let language = self.language {
            try container.encode(language, forKey: .language)
        }

        if let country = self.country {
            try container.encode(country, forKey: .country)
        }
    }
    
    init(
        category: Category? = nil,
        language: Language? = nil,
        country: Country? = nil
    ) {
        self.category = category
        self.language = language
        self.country = country
    }
}
