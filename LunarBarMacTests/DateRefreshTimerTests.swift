//
//  DateRefreshTimerTests.swift
//  LunarBarMacTests
//

import XCTest
@testable import LunarBar

@MainActor
final class DateRefreshTimerTests: XCTestCase {
  func testSecondTimerFiresOnWallClockBoundary() async {
    var tickDates = [Date]()
    let alignedTick = expectation(description: "Timer fires on a wall-clock second boundary")

    let timer = DateRefreshTimer {
      tickDates.append(.now)
      if tickDates.count == 2 {
        alignedTick.fulfill()
      }
    }

    timer.dateFormat = "HH:mm:ss"
    await fulfillment(of: [alignedTick], timeout: 2)

    guard let tickDate = tickDates.last else {
      return XCTFail("Missing scheduled tick")
    }

    let fraction = tickDate.timeIntervalSince1970.truncatingRemainder(dividingBy: 1)
    XCTAssertLessThan(fraction, 0.15)
  }
}
