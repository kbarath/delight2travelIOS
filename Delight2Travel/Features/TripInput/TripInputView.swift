import SwiftUI

struct TripInputView: View {
    @ObservedObject var viewModel: TripInputViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                tripFormCard
                if let message = viewModel.errorMessage {
                    errorBanner(message)
                }
                if viewModel.lastResponse != nil {
                    yourRouteSection
                }
            }
            .padding()
            .padding(.bottom, 32)
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 48)
                .accessibilityHidden(true)
            Text("Checklist of travel documents for your trip.")
                .font(AppTypography.headline())
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var tripFormCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 20) {
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
                    placeholder: "e.g. Chennai",
                    accessibilityId: "destinationField"
                )

                goButton
            }
        }
    }

    private var layoversSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("LAYOVER CITIES (OPTIONAL)")
                    .font(AppTypography.label())
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Button {
                    viewModel.addLayover()
                } label: {
                    Text("+ Add layover")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.primaryButton)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundColor(AppColors.textSecondary.opacity(0.6))
                        )
                }
                .accessibilityIdentifier("addLayoverButton")
            }

            ForEach(Array(viewModel.layovers.enumerated()), id: \.offset) { index, _ in
                HStack(spacing: 8) {
                    TextField("City name", text: Binding(
                        get: { viewModel.layovers.indices.contains(index) ? viewModel.layovers[index] : "" },
                        set: { new in
                            var copy = viewModel.layovers
                            if copy.indices.contains(index) {
                                copy[index] = new
                                viewModel.layovers = copy
                            }
                        }
                    ))
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .foregroundColor(AppColors.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accessibilityIdentifier("layoverField_\(index)")

                    Button {
                        viewModel.removeLayover(at: index)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .accessibilityIdentifier("removeLayover_\(index)")
                }
            }
        }
    }

    private var goButton: some View {
        Button {
            Task { await viewModel.submit() }
        } label: {
            Text("Go")
                .font(AppTypography.headline())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryButton, AppColors.primaryButtonGradientEnd],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!viewModel.canSubmit || viewModel.isLoading)
        .opacity(viewModel.isLoading ? 0.7 : 1)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            }
        }
        .accessibilityIdentifier("goButton")
    }

    // MARK: - Your route (single-page results)

    private var yourRouteSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Your route")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.bottom, 16)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        routeTimeline
                        travelDocumentsNeeded
                    }
                }
                .frame(maxHeight: 400)
            }
        }
        .accessibilityIdentifier("resultsList")
    }

    private var routeTimeline: some View {
        let originCity = viewModel.origin.trimmingCharacters(in: .whitespaces)
        let destinationCity = viewModel.destination.trimmingCharacters(in: .whitespaces)
        let layoverCities = viewModel.layovers.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }

        return VStack(alignment: .leading, spacing: 0) {
            routeNode(label: "ORIGIN", city: originCity, isLast: false)
            ForEach(Array(layoverCities.enumerated()), id: \.offset) { _, city in
                routeNode(label: "LAYOVER", city: city.isEmpty ? "—" : city, isLast: false)
            }
            routeNode(label: "DESTINATION", city: destinationCity, isLast: true)
        }
    }

    private func routeNode(label: String, city: String, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(AppColors.accentTeal)
                    .frame(width: 10, height: 10)
                if !isLast {
                    Rectangle()
                        .fill(AppColors.textSecondary.opacity(0.4))
                        .frame(width: 2)
                        .frame(minHeight: 28)
                }
            }
            .frame(width: 10)

            VStack(alignment: .leading, spacing: 6) {
                Text(label)
                    .font(AppTypography.label())
                    .foregroundColor(AppColors.textSecondary)
                Text(city.isEmpty ? "—" : city)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            .padding(.bottom, isLast ? 0 : 12)

            Spacer(minLength: 0)
        }
    }

    private var travelDocumentsNeeded: some View {
        let documents = viewModel.lastResponse?.displayDocumentNames ?? []

        return VStack(alignment: .leading, spacing: 10) {
            Text("TRAVEL DOCUMENTS NEEDED")
                .font(AppTypography.label())
                .foregroundColor(AppColors.textSecondary)
                .padding(.top, 8)

            if documents.isEmpty {
                Text("No specific documents returned for this route.")
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.textSecondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(documents, id: \.self) { name in
                        HStack(spacing: 10) {
                            Image(systemName: "doc.fill")
                                .font(.body)
                                .foregroundColor(AppColors.accentTeal)
                            Text(name)
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
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
