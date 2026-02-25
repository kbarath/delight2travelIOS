import SwiftUI

struct DocumentsResultsView: View {
    let viewModel: ResultsViewModel

    var body: some View {
        ZStack {
            GradientBackground()
            ScrollView {
                VStack(spacing: 20) {
                    documentsCard
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
}
