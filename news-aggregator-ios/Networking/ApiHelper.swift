import Foundation

enum ApiHelper {
    static func mapValuesToQueryItems(_ source: Codable) -> [URLQueryItem]? {
        let destination = source.toJSON()
            .compactMap { key, value -> URLQueryItem? in
                if let collection = value as? [String] {
                    let value = collection.joined(separator: .comma)
                    return URLQueryItem(name: key, value: value)
                } else if let value = value as? String {
                    return URLQueryItem(name: key, value: value)
                } else if let value = value as? Int {
                    return URLQueryItem(name: key, value: String(value))
                } else {
                    return nil
                }
            }

        if destination.isEmpty {
            return nil
        }

        return destination
    }
}

private extension Encodable {

    func toJSON(with encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
        guard let data = try? encoder.encode(self) else {
            return [:]
        }

        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return [:]
        }

        return json
    }
}

private extension String {
    static let comma = ","
}
