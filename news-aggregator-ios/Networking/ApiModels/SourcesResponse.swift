import Foundation

struct SourcesResponse: Codable {
    let status: ApiError.Status
    let sources: [Source]
}
