import Foundation
import SwiftUI

@MainActor
final class TripInputViewModel: ObservableObject {
    @Published var origin: String = ""
    @Published var layovers: [String] = []
    @Published var destination: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showResults: Bool = false
    @Published var lastResponse: TravelDocumentsResponse?

    private let apiClient: TravelDocumentsAPIProtocol

    var canSubmit: Bool {
        !origin.trimmingCharacters(in: .whitespaces).isEmpty &&
        !destination.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(apiClient: TravelDocumentsAPIProtocol) {
        self.apiClient = apiClient
    }

    func addLayover() {
        layovers.append("")
    }

    func removeLayover(at index: Int) {
        guard index >= 0, index < layovers.count else { return }
        layovers.remove(at: index)
    }

    func didDismissResults() {
        showResults = false
    }

    func submit() async {
        guard canSubmit else { return }
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        let o = origin.trimmingCharacters(in: .whitespaces)
        let d = destination.trimmingCharacters(in: .whitespaces)
        let lays = layovers.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }

        do {
            let response = try await apiClient.fetchTravelDocuments(origin: o, layovers: lays, destination: d)
            lastResponse = response
            showResults = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
