import XCTest
@testable import d12Spellbook

final class d12SpellbookTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(d12Spellbook().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
