import Foundation

protocol TravelDocumentsAPIProtocol: Sendable {
    func fetchTravelDocuments(origin: String, layover: String, destination: String) async throws -> TravelDocumentsResponse
}

final class TravelDocumentsAPIClient: TravelDocumentsAPIProtocol {
    private let session: URLSession
    private let endpoint: APIEndpoint

    init(session: URLSession = .shared, endpoint: APIEndpoint = .travelDocuments) {
        self.session = session
        self.endpoint = endpoint
    }

    func fetchTravelDocuments(origin: String, layover: String, destination: String) async throws -> TravelDocumentsResponse {
        guard var components = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "layover", value: layover),
            URLQueryItem(name: "destination", value: destination)
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.server(statusCode: http.statusCode)
        }

        do {
            return try Self.decodeResponse(data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    /// Decodes API response, supporting direct JSON or common wrappers (e.g. n8n "body"/"data").
    private static func decodeResponse(_ data: Data) throws -> TravelDocumentsResponse {
        // 1. Direct: { "origin", "destination", "layover", "nationality", "documents": [...] }
        if let response = try? JSONDecoder().decode(TravelDocumentsResponse.self, from: data) {
            return response
        }

        // 2. Direct with snake_case keys: "by_leg", etc.
        let snakeDecoder = JSONDecoder()
        snakeDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let response = try? snakeDecoder.decode(TravelDocumentsResponse.self, from: data) {
            return response
        }

        // 3. Wrapped in "body" (common in n8n Respond to Webhook)
        struct BodyWrapper: Decodable {
            let body: TravelDocumentsResponse
        }
        if let wrapper = try? JSONDecoder().decode(BodyWrapper.self, from: data) {
            return wrapper.body
        }

        // 4. Wrapped in "data"
        struct DataWrapper: Decodable {
            let data: TravelDocumentsResponse
        }
        if let wrapper = try? JSONDecoder().decode(DataWrapper.self, from: data) {
            return wrapper.data
        }

        // 5. Wrapped in "json"
        struct JsonWrapper: Decodable {
            let json: TravelDocumentsResponse
        }
        if let wrapper = try? JSONDecoder().decode(JsonWrapper.self, from: data) {
            return wrapper.json
        }

        // 6. Fail with a more helpful error including response preview
        let preview = String(data: data.prefix(300), encoding: .utf8) ?? "<non-UTF8>"
        let decodingError = DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "Response is not valid JSON for travel documents. Expected object with 'documents' (array of strings), optional 'origin', 'destination', 'layover', 'nationality'. Preview: \(preview)")
        )
        throw decodingError
    }
}
