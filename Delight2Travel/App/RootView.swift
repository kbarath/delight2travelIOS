import SwiftUI

struct RootView: View {
    @StateObject private var tripInputVM = TripInputViewModel(apiClient: TravelDocumentsAPIClient())

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()
                TripInputView(viewModel: tripInputVM)
            }
            .navigationDestination(isPresented: $tripInputVM.showResults) {
                if let response = tripInputVM.lastResponse {
                    DocumentsResultsView(viewModel: ResultsViewModel(response: response))
                        .onDisappear { tripInputVM.didDismissResults() }
                }
            }
        }
    }
}
