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

    func testResponseDecoding() throws {
        let json = """
        { "origin": "Dallas", "destination": "Delhi", "layover": "", "nationality": "", "documents": ["Valid passport with at least 6 months validity", "India visa (e-visa or regular visa) if required"] }
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(TravelDocumentsResponse.self, from: data)
        XCTAssertEqual(response.origin, "Dallas")
        XCTAssertEqual(response.destination, "Delhi")
        XCTAssertEqual(response.layover, "")
        XCTAssertEqual(response.nationality, "")
        XCTAssertEqual(response.documents.count, 2)
        XCTAssertEqual(response.displayDocumentNames, ["Valid passport with at least 6 months validity", "India visa (e-visa or regular visa) if required"])
    }
}
