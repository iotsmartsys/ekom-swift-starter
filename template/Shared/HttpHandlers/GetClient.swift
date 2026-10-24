import Foundation

public final class GetClient: HTTPClientCore {
    /// GET simples a uma URL completa, decodificando JSON em T
    func getDecodable<T: Decodable>(
        endpoint: String,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        requestDecodable(endpoint: endpoint, completion: completion)
    }

    /// GET simples a uma URL completa, retornando o corpo como String
    func getRawData(
        endpoint: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        requestData(
            endpoint: endpoint,
            method: .GET,
            headers: [:],
            body: nil
        ) { result in
            switch result {
            case .failure(let err): completion(.failure(err))
            case .success(let data):
                let raw = String(data: data, encoding: .utf8) ?? ""
                DispatchQueue.main.async {
                    completion(.success(raw))
                }
            }
        }
    }

    /// GET com base + path + query, decodificando JSON em T
    func requestDecodable<T: Decodable>(
        endpoint: String,
        path: String? = nil,
        query: [String: String]? = nil,
        headers: [String: String] = [:],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        requestData(
            endpoint: endpoint,
            path: path,
            method: .GET,
            query: query,
            headers: headers,
            body: nil
        ) { result in
            switch result {
            case .failure(let err): completion(.failure(err))
            case .success(let data):
                do {
                    let decoded = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(APIError.decoding(error)))
                }
            }
        }
    }
}
