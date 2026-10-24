import Foundation

public final class PostClient: HTTPClientCore {
    /// POST JSON com body Encodable para uma URL completa, decodificando resposta em T
    func postJSON<B: Encodable, T: Decodable>(
        endpoint: String,
        body: B,
        as type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let headers = ["Content-Type": "application/json"]
            let data = try jsonEncoder.encode(body)
            requestData(
                endpoint: endpoint,
                method: .POST,
                headers: headers,
                body: data
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
        } catch { completion(.failure(error)) }
    }

    /// POST JSON com body Encodable para uma URL completa, retornando apenas sucesso/falha
    func postJSON<B: Encodable>(
        endpoint: String,
        body: B?,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        do {
            var data: Data? = nil
            let headers = ["Content-Type": "application/json"]
            if let body = body {
                data = try jsonEncoder.encode(body)
            }
            requestData(
                endpoint: endpoint,
                method: .POST,
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
