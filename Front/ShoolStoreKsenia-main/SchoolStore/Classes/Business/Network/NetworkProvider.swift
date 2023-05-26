 

import Foundation

// MARK: - NetworkProvider

protocol NetworkProvider {
    func mock<T: Decodable>(_ request: Request, completion: ((Result<T, Error>) -> Void)?,
                            keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy)
    func make<T: Decodable>(_ request: Request, completion: ((Result<T, Error>) -> Void)?,
                            keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy)
}

extension NetworkProvider {
    func mock<T: Decodable>(
        _ request: Request,
        completion: ((Result<T, Error>) -> Void)?,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) {
        mock(request, completion: completion, keyDecodingStrategy: keyDecodingStrategy)
    }

    func make<T: Decodable>(
        _ request: Request,
        completion: ((Result<T, Error>) -> Void)?,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys // this
    ) {
        make(request, completion: completion, keyDecodingStrategy: keyDecodingStrategy)
    }
    

}

// MARK: - NetworkProviderImpl

final class NetworkProviderImpl: NetworkProvider {
    
    
    
    // MARK: Lifecycle

    init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // MARK: Internal

    func mock<T: Decodable>(
        _ request: Request,
        completion: ((Result<T, Error>) -> Void)?,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) {
        serializeData(response: request.mock, completion: completion, keyDecodingStrategy: keyDecodingStrategy)
    }

    func make<T: Decodable>(
        _ request: Request,
        completion: ((Result<T, Error>) -> Void)?,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) {
        guard let urlRequest = requestBuilder.build(request) else {
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            self?.serializeData(response: data, completion: completion, keyDecodingStrategy: keyDecodingStrategy)
        }
        task.resume()
    }

    // MARK: Private

    private let decoder: JSONDecoder

    private let requestBuilder: RequestBuilder

    private func serializeData<T: Decodable>(
        response data: Data?,
        completion: ((Result<T, Error>) -> Void)?,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) {
        guard let data = data else {
            completion?(.failure(Errors.unknown))
            return
        }
        decoder.keyDecodingStrategy = keyDecodingStrategy
        if let response = try? decoder.decode(T.self, from: data) {
            completion?(.success(response))
        } else if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
            completion?(.failure(Errors.failedResponse(message: errorResponse.message, fields: errorResponse.fields)))
        } else {
            completion?(.failure(Errors.unknown))
        }
    }
    

}
