import SwiftUI

struct TripInputView: View {
    @ObservedObject var viewModel: TripInputViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                tripFormCard
                if let message = viewModel.errorMessage {
                    errorBanner(message)
                }
            }
            .padding()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "airplane.circle.fill")
                .font(.system(size: 44))
                .foregroundColor(AppColors.accentTeal)
            Text("Delight2Travel")
                .font(AppTypography.title())
                .foregroundColor(AppColors.textPrimary)
            Text("Docs Done. Departure Ready.")
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 20)
    }

    private var tripFormCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Checklist of travel documents for your trip.")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.textPrimary)

                LabeledTextField(
                    label: "ORIGIN CITY",
                    text: $viewModel.origin,
                    placeholder: "e.g. San Francisco",
                    accessibilityId: "originField"
                )

                layoversSection

                LabeledTextField(
                    label: "DESTINATION CITY",
                    text: $viewModel.destination,
                    placeholder: "e.g. Tokyo",
                    accessibilityId: "destinationField"
                )

                PrimaryButton(
                    title: "Go",
                    action: { Task { await viewModel.submit() } },
                    isEnabled: viewModel.canSubmit && !viewModel.isLoading,
                    accessibilityId: "goButton"
                )
                .opacity(viewModel.isLoading ? 0.7 : 1)
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
        }
    }

    private var layoversSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("LAYOVER CITIES (OPTIONAL)")
                    .font(AppTypography.label())
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Button {
                    viewModel.addLayover()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add layover")
                    }
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.primaryButton)
                }
                .accessibilityIdentifier("addLayoverButton")
            }

            ForEach(Array(viewModel.layovers.enumerated()), id: \.offset) { index, _ in
                HStack(spacing: 8) {
                    LabeledTextField(
                        label: "Layover \(index + 1)",
                        text: Binding(
                            get: { viewModel.layovers.indices.contains(index) ? viewModel.layovers[index] : "" },
                            set: { new in
                                var copy = viewModel.layovers
                                if copy.indices.contains(index) {
                                    copy[index] = new
                                    viewModel.layovers = copy
                                }
                            }
                        ),
                        placeholder: "City name"
                    )
                    .accessibilityIdentifier("layoverField_\(index)")

                    Button {
                        viewModel.removeLayover(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .accessibilityIdentifier("removeLayover_\(index)")
                }
            }
        }
    }

    private func errorBanner(_ message: String) -> some View {
        Text(message)
            .font(AppTypography.caption())
            .foregroundColor(.red)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityIdentifier("errorMessage")
    }
}
