import Foundation

protocol APIRequest {
    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    associatedtype ResponseType: Decodable
    associatedtype Parameters: Encodable
    var parameters: Parameters { get }
    var bodyParameterEncoder: JSONEncoder { get }
    var queryItemsParameterDateFormatter: ISO8601DateFormatter { get }
    var responseDecoder: JSONDecoder { get }
}

extension APIRequest {

    func urlRequest(rootURL: URL, headers: [String: String]) -> URLRequest {
        
        let url = rootURL.appendingPathComponent(endpoint.rawValue)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        if encodesParametersInURL {
            urlRequest.encodeQueryItems(parameters: parameters, dateFormatter: queryItemsParameterDateFormatter)
        } else {
            try? urlRequest.encodeBody(parameters: parameters, encoder: bodyParameterEncoder)
        }

        urlRequest.setHeaders(headers: headers)
        return urlRequest
    }

    private var encodesParametersInURL: Bool {
        switch method {
        case .GET: return true
        case .POST: return false
        }
    }

    // Default dates to standard ISO8601
    // This can be overidden on a per request basis for special formats
    var bodyParameterEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    var queryItemsParameterDateFormatter: ISO8601DateFormatter {
        return ISO8601DateFormatter()
    }

    var responseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

private extension URLRequest {

    mutating func setHeaders(headers: [String: String]) {
        for header in headers {
            self.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }

    mutating func encodeQueryItems(parameters: Encodable, dateFormatter: ISO8601DateFormatter) {

        guard let url else {
            return
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = parameters.asQueryItems(dateFormatter: dateFormatter)

        guard let encodedURL = urlComponents?.url else {
            return
        }

        self.url = encodedURL
    }

    mutating func encodeBody(parameters: Encodable, encoder: JSONEncoder) throws {
        httpBody = try encoder.encode(parameters)
    }
}

private extension Encodable {

    func asQueryItems(dateFormatter: ISO8601DateFormatter) -> [URLQueryItem] {
        return Mirror(reflecting: self)
            .children
            .map({ (label, value) in
                // Map any dates to correct format
                guard let date = value as? Date else {
                    return (label, value)
                }
                let formattedDate = dateFormatter.string(from: date)
                return (label, formattedDate)
            })
            .compactMap({ (label, value) in
                // If we need to pass boolean value here we can decide with the API team how best to represent
                // This should do for 'most' cases though
                guard let label else {
                    return nil
                }
                return URLQueryItem(name: label, value: "\(value)")
            })
    }
}
