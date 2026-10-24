import Foundation

enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }

// MARK: - Núcleo compartilhado (session, URL, headers, transporte)

// MARK: - Façade: APIClient delegando para clientes específicos por método

public final class APIClient {
    static let shared = APIClient()

    private let core: HTTPClientCore
    let get: GetClient
    let post: PostClient
    let put: PutClient
    let patch: PatchClient
    let deleteClient: DeleteClient

    init(session: URLSession = .shared) {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        self.core = HTTPClientCore(
            session: session,
            jsonDecoder: decoder,
            jsonEncoder: encoder
        )
        self.get = GetClient(
            session: session,
            jsonDecoder: decoder,
            jsonEncoder: encoder
        )
        self.post = PostClient(
            session: session,
            jsonDecoder: decoder,
            jsonEncoder: encoder
        )
        self.put = PutClient(
            session: session,
            jsonDecoder: decoder,
            jsonEncoder: encoder
        )
        self.patch = PatchClient(
            session: session,
            jsonDecoder: decoder,
            jsonEncoder: encoder
        )
        self.deleteClient = DeleteClient(
            session: session,
            jsonDecoder: decoder,
            jsonEncoder: encoder
        )
    }

    // MARK: - Compat: acesso ao transporte bruto (Data)
    func requestData(
        endpoint: String,
        path: String? = nil,
        method: HTTPMethod = .GET,
        query: [String: String]? = nil,
        headers: [String: String] = [:],
        body: Data? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        core.requestData(
            endpoint: endpoint,
            path: path,
            method: method,
            query: query,
            headers: headers,
            body: body,
            completion: completion
        )
    }

    // MARK: - Compat: versão decodificada (JSON -> Decodable) com método variável
    func requestDecodable<T: Decodable>(
        endpoint: String,
        path: String? = nil,
        method: HTTPMethod = .GET,
        query: [String: String]? = nil,
        headers: [String: String] = [:],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        switch method {
        case .GET:
            get.requestDecodable(
                endpoint: endpoint,
                path: path,
                query: query,
                headers: headers,
                completion: completion
            )
        default:
            core.requestData(
                endpoint: endpoint,
                path: path,
                method: method,
                query: query,
                headers: headers,
                body: nil
            ) { result in
                switch result {
                case .failure(let err): completion(.failure(err))
                case .success(let data):
                    do {
                        let decoded = try self.core.jsonDecoder.decode(
                            T.self,
                            from: data
                        )
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(APIError.decoding(error)))
                    }
                }
            }
        }
    }

    // MARK: - Atalhos (delegando para clientes por método)
    func getDecodable<T: Decodable>(
        endpoint: String,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        get.getDecodable(endpoint: endpoint, type: type, completion: completion)
    }

    func getRawData(
        endpoint: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        get.getRawData(endpoint: endpoint, completion: completion)
    }

    func postJSON<B: Encodable, T: Decodable>(
        endpoint: String,
        body: B,
        as type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        post.postJSON(endpoint: endpoint, body: body, as: type, completion: completion)
    }

    func postJSON<B: Encodable>(
        endpoint: String,
        body: B?,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        post.postJSON(endpoint: endpoint, body: body, completion: completion)
    }

    func patchJSON(
        _ endpoint: String,
        patches: [[String: Any]],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        patch.patchJSON(endpoint, patches: patches, completion: completion)
    }

    func putJSON<B: Encodable>(
        endpoint: String,
        body: B,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        put.putJSON(endpoint: endpoint, body: body, completion: completion)
    }

    func delete(endpoint: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        deleteClient.delete(endpoint: endpoint, completion: completion)
    }
}
