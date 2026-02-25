import XCTest
@testable import Delight2Travel

final class TravelDocumentsResponseTests: XCTestCase {

    func testDisplayDocumentNames() {
        let response = TravelDocumentsResponse(
            origin: "Dallas",
            destination: "Delhi",
            layover: "",
            nationality: "",
            documents: ["Passport", "Visa"]
        )
        XCTAssertEqual(response.displayDocumentNames, ["Passport", "Visa"])
    }

    func testDocumentsByLegIsEmpty() {
        let response = TravelDocumentsResponse(documents: ["Passport", "Visa"])
        XCTAssertTrue(response.documentsByLeg.isEmpty)
    }

    func testDecodingFromJSON() throws {
        let json = """
        {"origin":"Dallas","destination":"Delhi","layover":"","nationality":"","documents":["Valid passport","India visa"]}
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(TravelDocumentsResponse.self, from: data)
        XCTAssertEqual(response.origin, "Dallas")
        XCTAssertEqual(response.destination, "Delhi")
        XCTAssertEqual(response.documents, ["Valid passport", "India visa"])
    }
}
