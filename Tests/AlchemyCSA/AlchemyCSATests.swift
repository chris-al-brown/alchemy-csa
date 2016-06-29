import XCTest
@testable import AlchemyCSA

class AlchemyCSATests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(AlchemyCSA().text, "Hello, World!")
    }


    static var allTests : [(String, (AlchemyCSATests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
