import Foundation

public class HTTPClientCore {
    let session: URLSession
    let jsonDecoder: JSONDecoder
    let jsonEncoder: JSONEncoder

    init(session: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder(), jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }

    func requestData(endpoint: String, path: String? = nil, method: HTTPMethod = .GET,
                     query: [String: String]? = nil, headers: [String: String] = [:], body: Data? = nil,
                     completion: @escaping (Result<Data, Error>) -> Void) {
        guard let baseURL = ApiConfiguration.baseURL else {
            completion(.failure(NSError(domain: "API", code: 0, userInfo: [NSLocalizedDescriptionKey: "Configure a URL da API."])))
            return
        }
        var url = baseURL.appending(path: endpoint)
        if let path { url = url.appending(path: path) }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(APIError.invalidResponse)); return
        }
        if let query { components.queryItems = query.sorted { $0.key < $1.key }.map { URLQueryItem(name: $0.key, value: $0.value) } }
        guard let finalURL = components.url else { completion(.failure(APIError.invalidResponse)); return }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        ApiConfiguration.headers.merging(headers, uniquingKeysWith: { _, caller in caller }).forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        session.dataTask(with: request) { data, response, error in
            let result: Result<Data, Error>
            if let error { result = .failure(error) }
            else if let response = response as? HTTPURLResponse {
                if (200...299).contains(response.statusCode) { result = .success(data ?? Data()) }
                else { result = .failure(APIError.httpStatus(code: response.statusCode, body: nil)) }
            } else { result = .failure(APIError.invalidResponse) }
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
}
