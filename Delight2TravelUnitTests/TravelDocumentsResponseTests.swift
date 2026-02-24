import XCTest
@testable import Delight2Travel

final class TravelDocumentsResponseTests: XCTestCase {

    func testDisplayDocumentNamesFromDocuments() {
        let response = TravelDocumentsResponse(
            documents: [
                .init(name: "Passport", leg: nil),
                .init(name: "Visa", leg: "destination")
            ],
            byLeg: nil
        )
        XCTAssertEqual(response.displayDocumentNames, ["Passport", "Visa"])
    }

    func testDisplayDocumentNamesFromByLeg() {
        let response = TravelDocumentsResponse(
            documents: nil,
            byLeg: ["Tokyo": ["Passport", "Visa"], "Dubai": ["Passport"]]
        )
        let names = response.displayDocumentNames
        XCTAssertEqual(Set(names), ["Passport", "Visa"])
    }

    func testDocumentsByLeg() {
        let response = TravelDocumentsResponse(
            documents: nil,
            byLeg: ["Tokyo": ["Passport", "Visa"], "Dubai": ["Passport"]]
        )
        let byLeg = response.documentsByLeg
        XCTAssertEqual(byLeg.count, 2)
        let legs = Set(byLeg.map(\.leg))
        XCTAssertTrue(legs.contains("Tokyo"))
        XCTAssertTrue(legs.contains("Dubai"))
    }
}
