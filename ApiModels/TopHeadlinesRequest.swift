import Foundation

final class  TopHeadlinesRequest: Codable {
    let country: Country?
    let category: Category?
    let sources: [String]?
    let q: String?
    let pageSize: Int?
    let page: Int?
    
    private enum CodingKeys: String, CodingKey {
        case country
        case category
        case sources
        case q
        case pageSize
        case page
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        if let q = self.q {
            try container.encode(q, forKey: .q)
        }
        if let country = self.country {
            try container.encode(country, forKey: .country)
        }

        if let category = self.category {
            try container.encode(category, forKey: .category)
        }
        
        if let sources = self.sources {
            try container.encode(sources, forKey: .sources)
        }
        
        if let q = self.q {
            try container.encode(q, forKey: .q)
        }
        
        if let pageSize = self.pageSize {
            try container.encode(pageSize, forKey: .pageSize)
        }
        
        if let page = self.page {
            try container.encode(page, forKey: .page)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.country = try container.decode(Country?.self, forKey: .country)
        self.category = try container.decode(Category?.self, forKey: .category)
        self.sources = try container.decode([String]?.self, forKey: .sources)
        self.q = try container.decode(String?.self, forKey: .q)
        self.pageSize = try container.decode(Int?.self, forKey: .pageSize)
        self.page = try container.decode(Int?.self, forKey: .page)
    }
    
    init(
        country: Country? = nil,
        category: Category? = nil,
        sources: [String]? = nil,
        q: String? = nil,
        pageSize: Int? = nil,
        page: Int? = nil
    ) {
        self.country = country
        self.category = category
        self.sources = sources
        self.q = q
        self.pageSize = pageSize
        self.page = page
    }
}
