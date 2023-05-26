 

import Foundation

// MARK: - RequestBuilder

protocol RequestBuilder: AnyObject {
    func build(_ requestTarget: Request) -> URLRequest?
}

// MARK: - RequestBuilderImpl

final class RequestBuilderImpl: RequestBuilder {
    // MARK: Lifecycle

    init(dataService: DataService) {
        self.dataService = dataService
    }

    // MARK: Public

    public func build(_ requestTarget: Request) -> URLRequest? {
        guard let baseURL = URL(string: prefixHTTPs("\(apiURL)/"))
        else {
            return nil
        }
        var url = baseURL.appendingPathComponent(requestTarget.path)
        if let urlParams = requestTarget.urlParameters, let urlWithQueryParameters = append(to: url, urlParams) {
            url = urlWithQueryParameters
        }
        var request = URLRequest(url: url)
        request.setValue(requestTarget.contentType, forHTTPHeaderField: "Content-Type")
        request.httpMethod = requestTarget.method.rawValue.uppercased()
        request.httpBody = requestTarget.body
        requestTarget.regularHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return authenticate(requestTarget, request: &request)
    }

    // MARK: Internal
    
    static func encode<T: Encodable>(
        _ data: T,
        encoderKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
        encoderDateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    ) -> Data? {
        if let json = data as? [String: Any] {
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        } else {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = encoderKeyEncodingStrategy
            encoder.dateEncodingStrategy = encoderDateEncodingStrategy
            return try? encoder.encode(data)
        }
    }

    // MARK: Private

    private let dataService: DataService
    private let apiURL: String = "localhost:3000"

    private func prefixHTTPs(_ url: String) -> String {
        let prefix = "http://"
        return url.contains(prefix) ? url : prefix + url
    }

    private func append(to url: URL, _ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

        return urlComponents.url
    }

    private func authenticate(_ target: Request, request: inout URLRequest) -> URLRequest? {
        if target.authenticated, let accessToken = dataService.appState.accessToken {
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
