import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var accessibilityId: String?

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.headline())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isEnabled ? AppColors.primaryButton : AppColors.primaryButton.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
        .accessibilityIdentifier(accessibilityId ?? "primaryButton")
    }
}
