struct Articles: Codable {
    let source: ArticlesSource
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

struct ArticlesSource: Codable {
    let id: String
    let name: String
}
