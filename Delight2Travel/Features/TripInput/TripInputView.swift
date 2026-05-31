import SwiftUI

struct TripInputView: View {
    @ObservedObject var viewModel: TripInputViewModel
    
    @State private var nationalitySearchText: String = ""
    @FocusState private var isNationalityFieldFocused: Bool
    
    private let nationalityOptions: [String] = [
        "Afghanistan",
        "Albania",
        "Algeria",
        "Andorra",
        "Angola",
        "Antigua and Barbuda",
        "Argentina",
        "Armenia",
        "Australia",
        "Austria",
        "Azerbaijan",
        "Bahamas",
        "Bahrain",
        "Bangladesh",
        "Barbados",
        "Belarus",
        "Belgium",
        "Belize",
        "Benin",
        "Bhutan",
        "Bolivia",
        "Bosnia and Herzegovina",
        "Botswana",
        "Brazil",
        "Brunei Darussalam",
        "Bulgaria",
        "Burkina Faso",
        "Burundi",
        "Cabo Verde",
        "Cambodia",
        "Cameroon",
        "Canada",
        "Central African Republic",
        "Chad",
        "Chile",
        "China",
        "Colombia",
        "Comoros",
        "Congo",
        "Costa Rica",
        "Côte d'Ivoire",
        "Croatia",
        "Cuba",
        "Cyprus",
        "Czechia",
        "Democratic People's Republic of Korea",
        "Democratic Republic of the Congo",
        "Denmark",
        "Djibouti",
        "Dominica",
        "Dominican Republic",
        "Ecuador",
        "Egypt",
        "El Salvador",
        "Equatorial Guinea",
        "Eritrea",
        "Estonia",
        "Eswatini",
        "Ethiopia",
        "Fiji",
        "Finland",
        "France",
        "Gabon",
        "Gambia",
        "Georgia",
        "Germany",
        "Ghana",
        "Greece",
        "Grenada",
        "Guatemala",
        "Guinea",
        "Guinea-Bissau",
        "Guyana",
        "Haiti",
        "Honduras",
        "Hungary",
        "Iceland",
        "India",
        "Indonesia",
        "Iran (Islamic Republic of)",
        "Iraq",
        "Ireland",
        "Israel",
        "Italy",
        "Jamaica",
        "Japan",
        "Jordan",
        "Kazakhstan",
        "Kenya",
        "Kiribati",
        "Kuwait",
        "Kyrgyzstan",
        "Lao People's Democratic Republic",
        "Latvia",
        "Lebanon",
        "Lesotho",
        "Liberia",
        "Libya",
        "Liechtenstein",
        "Lithuania",
        "Luxembourg",
        "Madagascar",
        "Malawi",
        "Malaysia",
        "Maldives",
        "Mali",
        "Malta",
        "Marshall Islands",
        "Mauritania",
        "Mauritius",
        "Mexico",
        "Micronesia (Federated States of)",
        "Monaco",
        "Mongolia",
        "Montenegro",
        "Morocco",
        "Mozambique",
        "Myanmar",
        "Namibia",
        "Nauru",
        "Nepal",
        "Netherlands",
        "New Zealand",
        "Nicaragua",
        "Niger",
        "Nigeria",
        "North Macedonia",
        "Norway",
        "Oman",
        "Pakistan",
        "Palau",
        "Panama",
        "Papua New Guinea",
        "Paraguay",
        "Peru",
        "Philippines",
        "Poland",
        "Portugal",
        "Qatar",
        "Republic of Korea",
        "Republic of Moldova",
        "Romania",
        "Russian Federation",
        "Rwanda",
        "Saint Kitts and Nevis",
        "Saint Lucia",
        "Saint Vincent and the Grenadines",
        "Samoa",
        "San Marino",
        "Sao Tome and Principe",
        "Saudi Arabia",
        "Senegal",
        "Serbia",
        "Seychelles",
        "Sierra Leone",
        "Singapore",
        "Slovakia",
        "Slovenia",
        "Solomon Islands",
        "Somalia",
        "South Africa",
        "South Sudan",
        "Spain",
        "Sri Lanka",
        "Sudan",
        "Suriname",
        "Sweden",
        "Switzerland",
        "Syrian Arab Republic",
        "Tajikistan",
        "Thailand",
        "Timor-Leste",
        "Togo",
        "Tonga",
        "Trinidad and Tobago",
        "Tunisia",
        "Türkiye",
        "Turkmenistan",
        "Tuvalu",
        "Uganda",
        "Ukraine",
        "United Arab Emirates",
        "United Kingdom",
        "United Republic of Tanzania",
        "United States of America",
        "Uruguay",
        "Uzbekistan",
        "Vanuatu",
        "Venezuela (Bolivarian Republic of)",
        "Viet Nam",
        "Yemen",
        "Zambia",
        "Zimbabwe"
    ]
    
    private var filteredNationalityOptions: [String] {
        let query = nationalitySearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return nationalityOptions }
        return nationalityOptions.filter { $0.localizedCaseInsensitiveContains(query) }
    }
    
    private var shouldShowNationalityAutocomplete: Bool {
        isNationalityFieldFocused
        && !filteredNationalityOptions.isEmpty
        && filteredNationalityOptions.first != nationalitySearchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

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
                nationalityDropdown
                    .frame(maxWidth: 330, alignment: .leading)
                AirportSearchField(
                    label: "Origin",
                    text: $viewModel.origin,
                    placeholder: "e.g. SFO or San Francisco",
                    accessibilityId: "originCityField"
                )
                .frame(maxWidth: 330, alignment: .leading)

                layoversSection

                AirportSearchField(
                    label: "Destination",
                    text: $viewModel.destination,
                    placeholder: "e.g. LHR or London",
                    accessibilityId: "destinationCityField"
                )
                .frame(maxWidth: 330, alignment: .leading)



                goButton
            }
        }
    }
    
    private var nationalityDropdown: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Nationality")
                .font(AppTypography.label())
                .foregroundColor(AppColors.textSecondary)
            
            VStack(alignment: .leading, spacing: 8) {
                TextField(
                    "Select nationality",
                    text: $nationalitySearchText
                )
                .focused($isNationalityFieldFocused)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .textFieldStyle(.plain)
                .padding(12)
                .background(Color.white.opacity(0.08))
                .foregroundColor(AppColors.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityIdentifier("nationalityField")
                .onAppear {
                    if nationalitySearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        nationalitySearchText = viewModel.nationality
                    }
                }
                .onChange(of: nationalitySearchText) { _, newValue in
                    viewModel.nationality = newValue
                }
                
                if shouldShowNationalityAutocomplete {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(filteredNationalityOptions.prefix(12), id: \.self) { option in
                                Button {
                                    viewModel.nationality = option
                                    nationalitySearchText = option
                                    isNationalityFieldFocused = false
                                } label: {
                                    HStack {
                                        Text(option)
                                            .foregroundColor(AppColors.textPrimary)
                                            .lineLimit(1)
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                }
                                .accessibilityIdentifier("nationalityOption_\(option)")
                                
                                if option != filteredNationalityOptions.prefix(12).last {
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

    private var layoversSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("LAYOVER AIRPORTS (OPTIONAL)")
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
                HStack(alignment: .top, spacing: 8) {
                    AirportSearchField(
                        text: layoverBinding(at: index),
                        placeholder: "e.g. DXB or Dubai",
                        accessibilityId: "layoverField_\(index)",
                        showsLabel: false
                    )
                    .frame(maxWidth: 280, alignment: .leading)

                    Button {
                        viewModel.removeLayover(at: index)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.top, 10)
                    .accessibilityIdentifier("removeLayover_\(index)")
                }
            }
        }
    }

    private func layoverBinding(at index: Int) -> Binding<String> {
        Binding(
            get: { viewModel.layovers.indices.contains(index) ? viewModel.layovers[index] : "" },
            set: { new in
                var copy = viewModel.layovers
                if copy.indices.contains(index) {
                    copy[index] = new
                    viewModel.layovers = copy
                }
            }
        )
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
