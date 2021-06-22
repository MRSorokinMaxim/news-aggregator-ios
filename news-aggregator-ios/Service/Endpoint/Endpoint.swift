import Alamofire

protocol Endpoint: Alamofire.URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest {
    mutating func setJsonBody(_ body: Data) {
        httpBody = body
        
        if value(forHTTPHeaderField: "Content-Type") == nil {
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
