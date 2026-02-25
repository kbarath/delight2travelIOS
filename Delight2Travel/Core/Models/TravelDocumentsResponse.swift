import Foundation

struct TravelDocumentsResponse: Decodable {
    let origin: String
    let destination: String
    let layover: String
    let nationality: String
    let documents: [String]

    init(origin: String = "", destination: String = "", layover: String = "", nationality: String = "", documents: [String] = []) {
        self.origin = origin
        self.destination = destination
        self.layover = layover
        self.nationality = nationality
        self.documents = documents
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        origin = try c.decodeIfPresent(String.self, forKey: .origin) ?? ""
        destination = try c.decodeIfPresent(String.self, forKey: .destination) ?? ""
        layover = try c.decodeIfPresent(String.self, forKey: .layover) ?? ""
        nationality = try c.decodeIfPresent(String.self, forKey: .nationality) ?? ""
        documents = try c.decodeIfPresent([String].self, forKey: .documents) ?? []
    }

    private enum CodingKeys: String, CodingKey {
        case origin, destination, layover, nationality, documents
    }

    /// Flattened list of document names for display.
    var displayDocumentNames: [String] {
        documents
    }

    /// Documents grouped by leg for sectioned display. Empty for this response format (flat list).
    var documentsByLeg: [(leg: String, documents: [String])] {
        []
    }
}
