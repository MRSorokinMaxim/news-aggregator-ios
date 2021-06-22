import Foundation

extension DateFormatter {

    private enum DateFormatLenght: Int {
        case isoFormatLength = 20
    }

    static func dateFormatter(for date: String) -> DateFormatter {
        switch date.count {
        case DateFormatLenght.isoFormatLength.rawValue:
            return rfcFormatter
            
        default:
            return fullDateFormatter
        }
    }
    
    /// формат "2018-08-20T00:00:00.00000Z"
    static let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    /// формат "2018-08-20T00:00:00Z"
    static let rfcFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    /// Форматирует дату в формат "2018-08-20T00:00:00"
    static let isoFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
}
