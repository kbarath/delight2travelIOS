import SwiftUI

struct RootView: View {
    @StateObject private var tripInputVM = TripInputViewModel(apiClient: TravelDocumentsAPIClient())

    var body: some View {
        ZStack {
            GradientBackground()
            TripInputView(viewModel: tripInputVM)
        }
    }
}
