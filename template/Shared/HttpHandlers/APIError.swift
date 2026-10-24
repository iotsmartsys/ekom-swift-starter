import Foundation

enum APIError: LocalizedError {
    case invalidResponse
    case httpStatus(code: Int, body: String?)
    case emptyBody
    case decoding(Error)
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Resposta inválida do servidor"
        case .httpStatus(let code, _): return "Falha na requisição (HTTP \(code))."
        case .emptyBody: return "Resposta sem conteúdo (body vazio)"
        case .decoding(let err):
            return "Erro ao decodificar: \(err.localizedDescription)"
        case .other(let err): return err.localizedDescription
        }
    }
}
