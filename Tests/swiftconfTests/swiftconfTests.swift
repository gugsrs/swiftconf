import XCTest
@testable import swiftconf

final class swiftconfTests: XCTestCase {
    func testParseLine() {
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

    func testParseLineWithComment() {
		XCTAssertThrowsError(try swiftconf().parseLine("#TEST=123")) { error in
            XCTAssertEqual(error as! Errors, Errors.commentLine)
        }
    }

    static var allTests = [
        ("testParseLine", testParseLine),
    ]
}
