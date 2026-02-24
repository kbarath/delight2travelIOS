import Foundation
import SwiftUI

struct ResultsViewModel {
    let response: TravelDocumentsResponse

    var displayDocumentNames: [String] {
        response.displayDocumentNames
    }

    var documentsByLeg: [(leg: String, documents: [String])] {
        response.documentsByLeg
    }

    var hasByLeg: Bool {
        !response.documentsByLeg.isEmpty
    }
}
