import SwiftUI

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
    }
}
