import Foundation

final class AirportDatabase {
    static let shared = AirportDatabase()

    private let airports: [Airport]

    init(bundle: Bundle = .main) {
        if let url = bundle.url(forResource: "airports", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Airport].self, from: data) {
            airports = decoded
        } else {
            airports = []
        }
    }

    func airport(forCode code: String) -> Airport? {
        let upper = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !upper.isEmpty else { return nil }
        return airports.first { $0.code == upper }
    }

    func search(_ query: String, limit: Int = 12) -> [Airport] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let upper = trimmed.uppercased()
        var codeMatches: [Airport] = []
        var otherMatches: [Airport] = []

        for airport in airports {
            if airport.code.hasPrefix(upper) {
                codeMatches.append(airport)
            } else if airport.city.localizedCaseInsensitiveContains(trimmed)
                || airport.name.localizedCaseInsensitiveContains(trimmed)
                || airport.country.localizedCaseInsensitiveContains(trimmed) {
                otherMatches.append(airport)
            }

            if codeMatches.count + otherMatches.count >= limit {
                break
            }
        }

        return Array((codeMatches + otherMatches).prefix(limit))
    }
}
