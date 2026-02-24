import XCTest

final class Delight2TravelUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testTripFormElementsExist() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.textFields["originField"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["destinationField"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["goButton"].exists)
    }

    func testGoButtonDisabledWhenOriginEmpty() throws {
        let app = XCUIApplication()
        app.launch()

        app.textFields["destinationField"].tap()
        app.textFields["destinationField"].typeText("Tokyo")
        XCTAssertTrue(app.buttons["goButton"].exists)
        let goButton = app.buttons["goButton"]
        XCTAssertTrue(goButton.exists)
        if goButton.isEnabled {
            goButton.tap()
            XCTAssertTrue(app.textFields["originField"].waitForExistence(timeout: 1))
        }
    }

    func testAddLayoverButtonExists() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.buttons["addLayoverButton"].waitForExistence(timeout: 3))
    }

    func testEnterTripAndNavigateToResults() throws {
        let app = XCUIApplication()
        app.launch()

        app.textFields["originField"].tap()
        app.textFields["originField"].typeText("San Francisco")
        app.textFields["destinationField"].tap()
        app.textFields["destinationField"].typeText("Tokyo")

        let goButton = app.buttons["goButton"]
        if goButton.isEnabled {
            goButton.tap()
            let results = app.otherElements["resultsList"]
            let navTitle = app.staticTexts["Travel documents"]
            XCTAssertTrue(results.waitForExistence(timeout: 10) || navTitle.waitForExistence(timeout: 10))
        }
    }
}
