import Foundation

struct TripRequest: Encodable {
    let origin: String
    let layovers: [String]
    let destination: String

    enum CodingKeys: String, CodingKey {
        case origin, layovers, destination
    }
}
