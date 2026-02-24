import XCTest
@testable import Delight2Travel

@MainActor
final class TripInputViewModelTests: XCTestCase {

    func testInitialState() {
        let mock = MockTravelDocumentsAPI()
        let vm = TripInputViewModel(apiClient: mock)
        XCTAssertTrue(vm.origin.isEmpty)
        XCTAssertTrue(vm.destination.isEmpty)
        XCTAssertTrue(vm.layovers.isEmpty)
        XCTAssertFalse(vm.canSubmit)
    }

    func testCanSubmitRequiresOriginAndDestination() {
        let mock = MockTravelDocumentsAPI()
        let vm = TripInputViewModel(apiClient: mock)
        vm.origin = "SF"
        XCTAssertFalse(vm.canSubmit)
        vm.destination = "Tokyo"
        XCTAssertTrue(vm.canSubmit)
        vm.origin = ""
        XCTAssertFalse(vm.canSubmit)
    }

    func testAddLayover() {
        let mock = MockTravelDocumentsAPI()
        let vm = TripInputViewModel(apiClient: mock)
        XCTAssertEqual(vm.layovers.count, 0)
        vm.addLayover()
        XCTAssertEqual(vm.layovers.count, 1)
        vm.addLayover()
        XCTAssertEqual(vm.layovers.count, 2)
    }

    func testRemoveLayover() {
        let mock = MockTravelDocumentsAPI()
        let vm = TripInputViewModel(apiClient: mock)
        vm.layovers = ["Dubai", "Singapore"]
        vm.removeLayover(at: 0)
        XCTAssertEqual(vm.layovers, ["Singapore"])
        vm.removeLayover(at: 0)
        XCTAssertEqual(vm.layovers, [])
    }

    func testSubmitCallsAPIWithTrimmedValues() async {
        let mock = MockTravelDocumentsAPI()
        let vm = TripInputViewModel(apiClient: mock)
        vm.origin = "  SF  "
        vm.destination = " Tokyo "
        vm.layovers = ["  Dubai  "]
        await vm.submit()
        XCTAssertEqual(mock.lastOrigin, "SF")
        XCTAssertEqual(mock.lastDestination, "Tokyo")
        XCTAssertEqual(mock.lastLayovers, ["Dubai"])
    }

    func testSubmitShowsResultsOnSuccess() async {
        let mock = MockTravelDocumentsAPI()
        mock.result = .success(TravelDocumentsResponse(documents: [.init(name: "Passport", leg: nil)], byLeg: nil))
        let vm = TripInputViewModel(apiClient: mock)
        vm.origin = "SF"
        vm.destination = "Tokyo"
        await vm.submit()
        XCTAssertTrue(vm.showResults)
        XCTAssertNotNil(vm.lastResponse)
        XCTAssertEqual(vm.lastResponse?.displayDocumentNames, ["Passport"])
    }

    func testSubmitShowsErrorOnFailure() async {
        let mock = MockTravelDocumentsAPI()
        mock.result = .failure(APIError.network(NSError(domain: "test", code: -1, userInfo: nil)))
        let vm = TripInputViewModel(apiClient: mock)
        vm.origin = "SF"
        vm.destination = "Tokyo"
        await vm.submit()
        XCTAssertFalse(vm.showResults)
        XCTAssertNotNil(vm.errorMessage)
    }

    func testDidDismissResults() {
        let mock = MockTravelDocumentsAPI()
        let vm = TripInputViewModel(apiClient: mock)
        vm.showResults = true
        vm.didDismissResults()
        XCTAssertFalse(vm.showResults)
    }
}
