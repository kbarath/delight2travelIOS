import Foundation

protocol TravelDocumentsAPIProtocol: Sendable {
    func fetchTravelDocuments(origin: String, layovers: [String], destination: String) async throws -> TravelDocumentsResponse
}

final class TravelDocumentsAPIClient: TravelDocumentsAPIProtocol {
    private let session: URLSession
    private let endpoint: APIEndpoint

    init(session: URLSession = .shared, endpoint: APIEndpoint = .travelDocuments) {
        self.session = session
        self.endpoint = endpoint
    }

    func fetchTravelDocuments(origin: String, layovers: [String], destination: String) async throws -> TravelDocumentsResponse {
        let request = TripRequest(origin: origin, layovers: layovers, destination: destination)
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.server(statusCode: http.statusCode)
        }

        do {
            return try JSONDecoder().decode(TravelDocumentsResponse.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
