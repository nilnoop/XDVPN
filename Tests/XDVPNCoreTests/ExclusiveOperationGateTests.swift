import Foundation
import XCTest
@testable import XDVPNCore

final class ExclusiveOperationGateTests: XCTestCase {
    func test_serializesConcurrentOperations() {
        let gate = ExclusiveOperationGate()
        let finished = expectation(description: "both operations finish")
        finished.expectedFulfillmentCount = 2
        var activeCount = 0
        var maximumActiveCount = 0

        for _ in 0..<2 {
            DispatchQueue.global().async {
                gate.perform {
                    activeCount += 1
                    maximumActiveCount = max(maximumActiveCount, activeCount)
                    Thread.sleep(forTimeInterval: 0.05)
                    activeCount -= 1
                }
                finished.fulfill()
            }
        }

        wait(for: [finished], timeout: 1)
        XCTAssertEqual(maximumActiveCount, 1)
    }
}
