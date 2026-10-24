import Foundation

/// Transporte JSON opcional. Configure a URL e os cabeçalhos quando integrar uma API.
struct APIClient {
    let baseURL: URL
    var session: URLSession = .shared
    var headers: [String: String] = [:]

    func send<Response: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Data? = nil,
        as type: Response.Type
    ) async throws -> Response {
        let relativePath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = baseURL.appending(path: relativePath)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200...299).contains(response.statusCode) else {
            throw APIClientError.httpStatus(response.statusCode)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

enum APIClientError: LocalizedError {
    case invalidResponse
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: "Resposta HTTP inválida."
        case .httpStatus(let code): "A API retornou HTTP \(code)."
        }
    }
}
