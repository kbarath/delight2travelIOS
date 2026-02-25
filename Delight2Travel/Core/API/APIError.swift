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
            if code == 404 {
                return "Webhook not found (404). In n8n: turn the workflow ON (toggle top-right) and ensure the Webhook node uses POST and this URL."
            }
            return "Server error (code \(code)). Please try again."
        }
    }
}
