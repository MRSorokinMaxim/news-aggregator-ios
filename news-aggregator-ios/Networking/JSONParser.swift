import Foundation

final class JSONParser {
    
    enum JSONParserError: Error {
        case failDecodeObject
    }
    
    // MARK: - Public Properties
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        let dateFormatter = DateFormatter.dateFormatter(for: dateString)
        let date = dateFormatter.date(from: dateString)
        
        guard let formattedDate = date else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return formattedDate
    }
    
    
    // MARK: - Public
    
    func parse<T>(_ data: Data, type: T.Type) throws -> [T]? where T: Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        do {
            if jsonObject is [String: Any] {
                let value = try decoder.decode(T.self, from: data)
                return [value]
            } else {
                return try decoder.decode(SafelyDecodedArray<T>.self, from: data).elements
            }
        } catch {
            debugPrint("Fail decode object \(T.self): \(error)")
            throw JSONParserError.failDecodeObject
        }
    }
}
