import XCTest
@testable import swiftconf

final class swiftconfTests: XCTestCase {
    func testParseLine() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
		do {
			let parsedLine = try swiftconf().parseLine("TEST=123")
			XCTAssertEqual(parsedLine.key, "TEST")
			XCTAssertEqual(parsedLine.value as! String, "123")
		} catch Errors.commentLine {
			XCTFail("Error thrown")
			return
		} catch {
		}
    }

    static var allTests = [
        ("testParseLine", testParseLine),
    ]
}
