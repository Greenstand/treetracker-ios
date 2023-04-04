import Foundation

protocol APIRequest {
    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    associatedtype ResponseType: Decodable
    associatedtype Parameters: Encodable
    var parameters: Parameters { get }
}

extension APIRequest {

    func urlRequest(rootURL: URL, headers: [String: String]) -> URLRequest {
        
        let url = rootURL.appendingPathComponent(endpoint.rawValue)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        if encodesParametersInURL {

            let encodedURL: URL? = {

                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                urlComponents?.queryItems = Mirror(reflecting: parameters)
                    .children
                    .map({ (label, value) in
                        // Map any dates to ISO8601 format
                        guard let date = value as? Date else {
                            return (label, value)
                        }
                        let dateFormatter = ISO8601DateFormatter()
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

                return urlComponents?.url
            }()

            if let encodedURL {
                urlRequest.url = encodedURL
            }

        } else {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            urlRequest.httpBody = try? jsonEncoder.encode(parameters)
        }

        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        return urlRequest
    }

    private var encodesParametersInURL: Bool {
        switch method {
        case .GET: return true
        case .POST: return false
        }
    }
}
