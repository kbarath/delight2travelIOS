import XCTest
@testable import Delight2Travel

final class AirportDatabaseTests: XCTestCase {

    private var database: AirportDatabase!

    override func setUp() {
        super.setUp()
        database = AirportDatabase(bundle: Bundle(for: AirportDatabase.self))
    }

    func testSearchByIATACodePrefix() {
        let results = database.search("SF")
        XCTAssertTrue(results.contains { $0.code == "SFO" })
    }

    func testSearchByCityName() {
        let results = database.search("San Francisco")
        XCTAssertTrue(results.contains { $0.code == "SFO" })
    }

    func testAirportForCode() {
        let airport = database.airport(forCode: "sfo")
        XCTAssertEqual(airport?.code, "SFO")
        XCTAssertEqual(airport?.city, "San Francisco")
    }

    func testEmptyQueryReturnsNoResults() {
        XCTAssertTrue(database.search("").isEmpty)
        XCTAssertTrue(database.search("   ").isEmpty)
    }
}
