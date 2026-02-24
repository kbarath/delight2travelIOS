import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case network(Error)
    case invalidResponse
    case decoding(Error)
    case server(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server."
        case .decoding(let error):
            return "Could not read response: \(error.localizedDescription)"
        case .server(let code):
            return "Server error (code \(code)). Please try again."
        }
    }
}
