import Foundation

enum APIEndpoint {
    case travelDocuments

    var url: URL {
        switch self {
        case .travelDocuments:
            return Configuration.apiBaseURL
        }
    }

    var method: String { "GET" }
}
