import Foundation

class HttpService {
    /// Cliente base para GET com decodificação JSON
    func getData<T: Decodable>(
        _ endpoint: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        APIClient.shared.getDecodable(endpoint: endpoint, type: T.self) { result in
            switch result {
            case .success(let model): completion(.success(model))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func getRawData(
        _ endpoint: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        APIClient.shared.getRawData(endpoint: endpoint) { result in
            switch result {
            case .success(let data): completion(.success(data))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func delete(_ endpoint: String, completion: @escaping (Result<Bool, Error>) -> Void)
    {
        APIClient.shared.delete(endpoint: endpoint) { result in
            switch result {
            case .success(let success): completion(.success(success))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    /// PATCH com body JSON (Encodable) e resposta Decodable
    func patchJSON(
        _ endpoint: String,
        body: [[String: Any]],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        APIClient.shared.patchJSON(endpoint, patches: body) { result in
            switch result {
            case .success(let model): completion(.success(model))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    /// PUT com body JSON (Encodable) e resposta Decodable
    func putJSON<B: Encodable>(
        _ endpoint: String,
        body: B,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        APIClient.shared.putJSON(endpoint: endpoint, body: body) { result in
            switch result {
            case .success(let model): completion(.success(model))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func postJSON<B: Encodable>(
        _ endpoint: String,
        body: B?,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        APIClient.shared.postJSON(endpoint: endpoint, body: body) { result in
            switch result {
            case .success(let model): completion(.success(model))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

}

// MARK: - Variantes async/await
extension HttpService {
    func getData<T: Decodable>(_ endpoint: String) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.getData(endpoint) { (result: Result<T, Error>) in
                continuation.resume(with: result)
            }
        }
    }

    func getRawData(_ endpoint: String) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            self.getRawData(endpoint) { result in
                continuation.resume(with: result)
            }
        }
    }

    func delete(_ endpoint: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            self.delete(endpoint) { result in
                continuation.resume(with: result)
            }
        }
    }

    func patchJSON(_ endpoint: String, body: [[String: Any]]) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            self.patchJSON(endpoint, body: body) { result in
                continuation.resume(with: result)
            }
        }
    }

    func putJSON<B: Encodable>(_ endpoint: String, body: B) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            self.putJSON(endpoint, body: body) { result in
                continuation.resume(with: result)
            }
        }
    }

    func postJSON<B: Encodable>(_ endpoint: String, body: B?) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            self.postJSON(endpoint, body: body) { result in
                continuation.resume(with: result)
            }
        }
    }
}

