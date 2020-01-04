import XCTest
@testable import IndexTrie

final class IndexTrieTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(IndexTrie().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
