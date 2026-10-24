import Foundation

public final class PatchClient: HTTPClientCore {
    /// PATCH JSON (RFC 6902-like) usando array de objetos
    func patchJSON(
        _ endpoint: String,
        patches: [[String: Any]],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        do {
            let headers = ["Content-Type": "application/json"]
            let data = try JSONSerialization.data(withJSONObject: patches, options: [])
            requestData(
                endpoint: endpoint,
                method: .PATCH,
                headers: headers,
                body: data
            ) { result in
                switch result {
                case .failure(let err): completion(.failure(err))
                case .success:
                    completion(.success(true))
                }
            }
        } catch { completion(.failure(error)) }
    }
}
