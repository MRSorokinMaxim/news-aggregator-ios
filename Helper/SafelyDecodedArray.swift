import Foundation

/// Структура позволяет декодировать массив, пропуская невалидные элементы
struct SafelyDecodedArray<T: Decodable>: Decodable {
    var elements: [T]
    var errors: [Error]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        (elements, errors) = try container.safelyDecodeArray(T.self)
    }
}


/// Структура позволяет декодеру пропустить элемент, который не может быть декодирован
private struct EmptyDecodable: Decodable {}

extension UnkeyedDecodingContainer {
    
    /// Возвращает массив элементов, за исключением тех, которые не могут быть декодированы
    mutating func safelyDecodeArray<T: Decodable>(_ type: T.Type) throws -> ([T], [Error]) {
        var elements = [T]()
        var errors = [Error]()
        elements.reserveCapacity(count ?? 0)
        while !isAtEnd {
            do {
                elements.append(try decode(T.self))
            } catch {
                if let decodingError = error as? DecodingError {
                    print("\(T.self): Fail decode object: \(decodingError)")
                } else {
                    print("\(T.self): Fail decode object: \(error)")
                }
                errors.append(error)
                /// Пропускаем текущий элемент и переходим к следующему
                /// https://bugs.swift.org/browse/SR-5953
                _ = try? decode(EmptyDecodable.self)
            }
        }
        return (elements, errors)
    }
}
