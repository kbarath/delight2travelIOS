import XCTest
@testable import Delight2Travel

final class TripRequestTests: XCTestCase {

    func testEncodeDecodeRoundTrip() throws {
        let request = TripRequest(origin: "Paris", layovers: ["London"], destination: "Tokyo")
        let data = try JSONEncoder().encode(request)
        let decoded = try JSONDecoder().decode(TripRequest.self, from: data)
        XCTAssertEqual(decoded.origin, request.origin)
        XCTAssertEqual(decoded.layovers, request.layovers)
        XCTAssertEqual(decoded.destination, request.destination)
    }

    func testEmptyLayovers() throws {
        let request = TripRequest(origin: "A", layovers: [], destination: "B")
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let layovers = json?["layovers"] as? [String]
        XCTAssertEqual(layovers, [])
    }
}
