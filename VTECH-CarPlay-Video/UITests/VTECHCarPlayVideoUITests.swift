import XCTest

final class VTECHCarPlayVideoUITests: XCTestCase {
    override func setUpWithError() throws { continueAfterFailure = false }
    func testParkingConfirmationGatesVideo() {
        let app = XCUIApplication()
        app.launch()
        let choose = app.buttons["chooseVideo"]
        XCTAssertTrue(choose.waitForExistence(timeout: 10))
        XCTAssertFalse(choose.isEnabled)
        let parked = app.switches["parkedToggle"]
        XCTAssertTrue(parked.exists)
        parked.tap()
        XCTAssertTrue(choose.isEnabled)
        parked.tap()
        XCTAssertFalse(choose.isEnabled)
    }
    func testVehicleNamePersistsAfterRelaunch() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        let field = app.textFields["vehicleName"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        let original = field.value as? String ?? "Tucson 2024"
        replace(field, with: "Xe kiem thu")
        app.buttons["closeSheet"].tap()
        app.terminate()
        app.launch()
        app.buttons["settingsButton"].tap()
        let restored = app.textFields["vehicleName"]
        XCTAssertTrue(restored.waitForExistence(timeout: 5))
        XCTAssertEqual(restored.value as? String, "Xe kiem thu")
        replace(restored, with: original)
        app.buttons["closeSheet"].tap()
    }
    private func replace(_ field: XCUIElement, with text: String) {
        field.tap()
        let current = field.value as? String ?? ""
        field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        field.typeText(text)
    }
}
