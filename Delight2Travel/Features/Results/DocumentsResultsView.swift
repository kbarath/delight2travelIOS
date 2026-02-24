import SwiftUI

struct DocumentsResultsView: View {
    let viewModel: ResultsViewModel

    var body: some View {
        ZStack {
            GradientBackground()
            ScrollView {
                VStack(spacing: 20) {
                    documentsCard
                    popularDestinationsCard
                    servicesCard
                }
                .padding()
            }
        }
        .navigationTitle("Travel documents")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var documentsCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Required documents")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.textPrimary)

                if viewModel.hasByLeg {
                    ForEach(viewModel.documentsByLeg, id: \.leg) { leg, docs in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(leg)
                                .font(AppTypography.label())
                                .foregroundColor(AppColors.textSecondary)
                            ForEach(docs, id: \.self) { doc in
                                HStack(spacing: 8) {
                                    Image(systemName: "doc.fill")
                                        .font(.caption)
                                        .foregroundColor(AppColors.accentTeal)
                                    Text(doc)
                                        .font(AppTypography.body())
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                        }
                    }
                } else {
                    ForEach(viewModel.displayDocumentNames, id: \.self) { name in
                        HStack(spacing: 8) {
                            Image(systemName: "doc.fill")
                                .font(.caption)
                                .foregroundColor(AppColors.accentTeal)
                            Text(name)
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }

                if viewModel.displayDocumentNames.isEmpty {
                    Text("No specific documents returned for this route.")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .accessibilityIdentifier("resultsList")
    }

    private var popularDestinationsCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Popular destinations")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.textPrimary)
                Text("Documents typically required")
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)

                VStack(alignment: .leading, spacing: 6) {
                    destinationRow("Tokyo", docs: "Passport, Visa, Travel insurance")
                    destinationRow("Paris", docs: "Passport, Schengen visa")
                    destinationRow("Dubai", docs: "Passport, Visa on arrival / e-Visa")
                    destinationRow("Singapore", docs: "Passport, Visa (if required)")
                    destinationRow("London", docs: "Passport, UK visa")
                }
            }
        }
    }

    private func destinationRow(_ city: String, docs: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(city):")
                .font(AppTypography.body())
                .foregroundColor(AppColors.textPrimary)
                .frame(width: 90, alignment: .leading)
            Text(docs)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var servicesCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Services we offer")
                    .font(AppTypography.headline())
                    .foregroundColor(AppColors.textPrimary)
                Text("Make your trip smoother")
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary)

                let services = [
                    "Visa assistance",
                    "Airport pick-up & drop",
                    "Travel SIM cards",
                    "Travel insurance",
                    "Hotel & transport bookings"
                ]
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(services, id: \.self) { service in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.successCheck)
                            Text(service)
                                .font(AppTypography.body())
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
            }
        }
    }
}
