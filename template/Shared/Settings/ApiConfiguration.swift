import Foundation

enum ApiConfiguration {
    // Demonstração local por padrão. Configure uma API antes de desativar.
    static var usesDemoData = true
    static var baseURL: URL? = nil
    static var headers: [String: String] = [:]
}
