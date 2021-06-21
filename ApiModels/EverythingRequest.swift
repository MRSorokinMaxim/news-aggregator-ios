import Foundation

final class EverythingRequest: Codable {
    let q: String?
    let qInTitle: String?
    let sources: [String]?
    let domains: [String]?
    let excludeDomains: [String]?
    let from: Date?
    let to: Date?
    let language: Language?
    let sortBy: Sorted?
    let pageSize: Int?
    let page: Int?
    
    private enum CodingKeys: String, CodingKey {
        case q
        case qInTitle
        case sources
        case domains
        case excludeDomains
        case from
        case to
        case language
        case sortBy
        case pageSize
        case page
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        if let q = self.q {
            try container.encode(q, forKey: .q)
        }
        if let qInTitle = self.qInTitle {
            try container.encode(qInTitle, forKey: .qInTitle)
        }

        if let sources = self.sources {
            try container.encode(sources, forKey: .sources)
        }
        
        if let domains = self.domains {
            try container.encode(domains, forKey: .domains)
        }
        
        if let excludeDomains = self.excludeDomains {
            try container.encode(excludeDomains, forKey: .excludeDomains)
        }
        
        if let from = self.from {
            try container.encode(DateFormatter.isoFormatter.string(from: from), forKey: .from)
        }
        
        if let to = self.to {
            try container.encode(DateFormatter.isoFormatter.string(from: to), forKey: .to)
        }
        
        if let language = self.language {
            try container.encode(language, forKey: .language)
        }
        
        if let sortBy = self.sortBy {
            try container.encode(sortBy, forKey: .sortBy)
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
    
        self.q = try container.decode(String?.self, forKey: .q)
        self.qInTitle = try container.decode(String?.self, forKey: .qInTitle)
        self.sources = try container.decode([String]?.self, forKey: .sources)
        self.domains = try container.decode([String]?.self, forKey: .domains)
        self.excludeDomains = try container.decode([String]?.self, forKey: .excludeDomains)
        
        let dateFrom = try container.decode(String.self, forKey: .from)
        self.from = DateFormatter.isoFormatter.date(from: dateFrom)
        
        let dateTo = try container.decode(String.self, forKey: .to)
        self.to = DateFormatter.isoFormatter.date(from: dateTo)
        
        self.language = try container.decode(Language?.self, forKey: .language)
        self.sortBy = try container.decode(Sorted?.self, forKey: .sortBy)
        self.pageSize = try container.decode(Int?.self, forKey: .pageSize)
        self.page = try container.decode(Int?.self, forKey: .page)
    }
    
    init(
        q: String? = nil,
        qInTitle: String? = nil,
        sources: [String]? = nil,
        domains: [String]? = nil,
        excludeDomains: [String]? = nil,
        from: Date? = nil,
        to: Date? = nil,
        language: Language? = nil,
        sortBy: Sorted? = nil,
        pageSize: Int? = nil,
        page: Int? = nil
    ) {
        self.q = q
        self.qInTitle = qInTitle
        self.sources = sources
        self.domains = domains
        self.excludeDomains = excludeDomains
        self.from = from
        self.to = to
        self.language = language
        self.sortBy = sortBy
        self.pageSize = pageSize
        self.page = page
    }
}
