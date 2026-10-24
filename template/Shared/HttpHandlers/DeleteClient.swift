import Foundation

public final class DeleteClient: HTTPClientCore {
    /// DELETE request to a full URL
    func delete(endpoint: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        requestData(endpoint: endpoint, method: .DELETE, headers: [:], body: nil) { result in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success:
                completion(.success(true))
            }
        }
    }
}
