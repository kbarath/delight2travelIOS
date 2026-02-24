import Foundation

struct TravelDocumentsResponse: Decodable {
    let documents: [DocumentItem]?
    let byLeg: [String: [String]]?

    init(documents: [DocumentItem]?, byLeg: [String: [String]]?) {
        self.documents = documents
        self.byLeg = byLeg
    }

    struct DocumentItem: Decodable {
        let name: String
        let leg: String?
    }

    /// Flattened list of document names for display (from documents array or byLeg).
    var displayDocumentNames: [String] {
        if let docs = documents, !docs.isEmpty {
            return docs.map { $0.name }
        }
        if let byLeg = byLeg {
            return Array(Set(byLeg.values.flatMap { $0 })).sorted()
        }
        return []
    }

    /// Documents grouped by leg for sectioned display.
    var documentsByLeg: [(leg: String, documents: [String])] {
        if let byLeg = byLeg {
            return byLeg.map { (leg: $0.key, documents: $0.value) }.sorted { $0.leg < $1.leg }
        }
        if let docs = documents, !docs.isEmpty {
            let grouped = Dictionary(grouping: docs, by: { $0.leg ?? "General" })
            return grouped.map { (leg: $0.key, documents: $0.value.map { $0.name }) }.sorted { $0.leg < $1.leg }
        }
        return []
    }
}
