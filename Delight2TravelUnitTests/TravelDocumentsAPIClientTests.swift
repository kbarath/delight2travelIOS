import XCTest
@testable import Delight2Travel

final class TravelDocumentsAPIClientTests: XCTestCase {

    func testRequestEncoding() throws {
        let request = TripRequest(origin: "SF", layovers: ["Dubai"], destination: "Tokyo")
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertEqual(json?["origin"] as? String, "SF")
        XCTAssertEqual(json?["destination"] as? String, "Tokyo")
        let layovers = json?["layovers"] as? [String]
        XCTAssertEqual(layovers, ["Dubai"])
    }

    func testResponseDecodingDocumentsArray() throws {
        let json = """
        { "documents": [ { "name": "Passport", "leg": "destination" }, { "name": "Visa", "leg": null } ] }
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(TravelDocumentsResponse.self, from: data)
        XCTAssertEqual(response.documents?.count, 2)
        XCTAssertEqual(response.displayDocumentNames, ["Passport", "Visa"])
    }

    func testResponseDecodingByLeg() throws {
        let json = """
        { "byLeg": { "Tokyo": ["Passport", "Visa"], "Dubai": ["Passport"] } }
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(TravelDocumentsResponse.self, from: data)
        XCTAssertEqual(response.byLeg?["Tokyo"], ["Passport", "Visa"])
        XCTAssertTrue(response.displayDocumentNames.contains("Passport"))
        XCTAssertTrue(response.displayDocumentNames.contains("Visa"))
    }
}
