import Foundation

struct Airport: Codable, Identifiable, Hashable {
    let code: String
    let name: String
    let city: String
    let country: String

    var id: String { code }

    var displayLabel: String {
        "\(code) — \(city)"
    }
}
