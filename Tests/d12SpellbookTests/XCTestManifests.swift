import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(d12SpellbookTests.allTests),
    ]
}
#endif