struct BaseArticleResponse: Codable {
    let status: ApiError.Status
    let totalResults: Int
    let articles: [Article]
}
