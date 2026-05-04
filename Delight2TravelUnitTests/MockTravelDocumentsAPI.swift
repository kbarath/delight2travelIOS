import Foundation
@testable import Delight2Travel

final class MockTravelDocumentsAPI: TravelDocumentsAPIProtocol, @unchecked Sendable {
    var result: Result<TravelDocumentsResponse, Error> = .failure(APIError.invalidResponse)
    var lastOrigin: String?
    var lastDestination: String?
    var lastNationality: String?
    var lastLayovers: [String]?

    func fetchTravelDocuments(origin: String, layover: String, destination: String, nationality: String) async throws -> TravelDocumentsResponse {
        lastOrigin = origin
        lastDestination = destination
        lastNationality = nationality
        lastLayovers = layover
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
