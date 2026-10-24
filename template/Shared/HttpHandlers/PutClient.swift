import Foundation

public final class PutClient: HTTPClientCore {
    /// PUT JSON com body Encodable para uma URL completa
    func putJSON<B: Encodable>(
        endpoint: String,
        body: B,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        do {
            let headers = ["Content-Type": "application/json"]
            let data = try jsonEncoder.encode(body)
            requestData(
                endpoint: endpoint,
                method: .PUT,
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
