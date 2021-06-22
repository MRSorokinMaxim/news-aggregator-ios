struct BaseArticlesResponse: Codable {
    let status: ApiError.Status
    let totalResults: Int
    let articles: [Articles]
}
