import XCTest
@testable import RKProgressBar

extension XCTestCase {
    struct AwaitError: Error {}
    func await<T>(_ function: (@escaping (T) -> Void) -> Void) throws -> T {
        let expectation = self.expectation(description: "Async call")
        var result: T?

        function() { value in
            result = value
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)

        guard let unwrappedResult = result else {
          throw AwaitError()
        }

        return unwrappedResult
    }
}

final class RKProgressBarTests: XCTestCase {
  func testPBInitializing() {
    let pb = RKProgressBar(innerMargin: 0.5, startAt: 0.78)
    XCTAssertEqual(pb.innerMargin, 0.5, "innerMargin is incorrectly initialised")
    XCTAssertEqual(pb.progress, 0.78, "Progress is incorrectly initialised")
  }
  func testProgressSet() {
    let pb = RKProgressBar(startAt: 0.3)
    pb.setProgress(to: 1.0)
    XCTAssert(
      pb.progress == 1.0,
      "Progress should be 1.0, instead: \(pb.progress)"
    )
  }

  static var allTests = [
    ("testPBInitializing", testPBInitializing),
    ("testProgressSet", testProgressSet),
  ]
}
