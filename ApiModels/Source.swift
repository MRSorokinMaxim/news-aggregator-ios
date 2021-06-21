import Foundation

struct Source: Codable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: Category
    let language: Language
    let country: Country
}
