import Foundation

enum Configuration {
    static var apiBaseURL: URL {
        guard let url = URL(string: "https://n8n.srv1148585.hstgr.cloud/webhook/dc3ae967-f844-47f4-8f53-f071a8e60181") else {
            fatalError("Invalid API base URL")
        }
        return url
    }
}
