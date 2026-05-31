import SwiftUI

struct AirportSearchField: View {
    let label: String?
    @Binding var text: String
    var placeholder: String = "Search by code or city"
    var accessibilityId: String?
    var showsLabel: Bool = true

    init(
        label: String? = nil,
        text: Binding<String>,
        placeholder: String = "Search by code or city",
        accessibilityId: String? = nil,
        showsLabel: Bool = true
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.accessibilityId = accessibilityId
        self.showsLabel = showsLabel
    }

    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool

    private let database = AirportDatabase.shared

    private var filteredAirports: [Airport] {
        database.search(searchText)
    }

    private var selectedDisplayLabel: String? {
        database.airport(forCode: text)?.displayLabel
    }

    private var shouldShowAutocomplete: Bool {
        isFocused
            && !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !filteredAirports.isEmpty
            && searchText != selectedDisplayLabel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showsLabel, let label {
                Text(label)
                    .font(AppTypography.label())
                    .foregroundColor(AppColors.textSecondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                TextField(placeholder, text: $searchText)
                    .focused($isFocused)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .foregroundColor(AppColors.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityIdentifier(accessibilityId ?? label ?? "airportSearchField")
                    .onAppear {
                        syncSearchTextFromBinding()
                    }
                    .onChange(of: searchText) { _, newValue in
                        if newValue == selectedDisplayLabel {
                            return
                        }
                        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                        if let airport = database.airport(forCode: trimmed) {
                            text = airport.code
                        } else {
                            text = trimmed
                        }
                    }
                    .onChange(of: text) { _, _ in
                        if !isFocused {
                            syncSearchTextFromBinding()
                        }
                    }

                if shouldShowAutocomplete {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(filteredAirports) { airport in
                                Button {
                                    text = airport.code
                                    searchText = airport.displayLabel
                                    isFocused = false
                                } label: {
                                    HStack(spacing: 10) {
                                        Text(airport.code)
                                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                            .foregroundColor(AppColors.accentTeal)
                                            .frame(width: 36, alignment: .leading)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(airport.city)
                                                .foregroundColor(AppColors.textPrimary)
                                                .lineLimit(1)
                                            Text(airport.country)
                                                .font(AppTypography.caption())
                                                .foregroundColor(AppColors.textSecondary)
                                                .lineLimit(1)
                                        }
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                }
                                .accessibilityIdentifier("airportOption_\(airport.code)")

                                if airport.id != filteredAirports.last?.id {
                                    Divider()
                                        .overlay(Color.white.opacity(0.08))
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 240)
                    .background(Color.black.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
            }
        }
    }

    private func syncSearchTextFromBinding() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchText = ""
            return
        }
        searchText = database.airport(forCode: trimmed)?.displayLabel ?? trimmed
    }
}
