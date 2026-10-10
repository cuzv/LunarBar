//
//  AppPreferencesTests.swift
//  LunarBarMacTests
//
//  Created by cyan on 12/31/23.
//

import XCTest
@testable import LunarBar

@MainActor
final class AppPreferencesTests: XCTestCase {
  func testSetEncodingDecoding() {
    AppPreferences.Mocked.setObjects.removeAll()
    XCTAssertEqual(AppPreferences.Mocked.setObjects, Set())

    AppPreferences.Mocked.setObjects.insert("Foo")
    AppPreferences.Mocked.setObjects.insert("Bar")
    XCTAssertEqual(AppPreferences.Mocked.setObjects, Set(["Foo", "Bar"]))

    AppPreferences.Mocked.setObjects.toggle("Foo")
    XCTAssertEqual(AppPreferences.Mocked.setObjects, Set(["Bar"]))
  }

  func testFixedTimeZoneEncodingDecoding() {
    AppPreferences.Mocked.fixedTimeZone = FixedTimeZone(offsetSeconds: 8 * 60 * 60)
    XCTAssertEqual(AppPreferences.Mocked.fixedTimeZone?.offsetSeconds, 8 * 60 * 60)
    XCTAssertEqual(AppPreferences.Mocked.fixedTimeZone?.displayName, "UTC+08:00")

    AppPreferences.Mocked.fixedTimeZone = FixedTimeZone(offsetSeconds: -(3 * 60 + 30) * 60)
    XCTAssertEqual(AppPreferences.Mocked.fixedTimeZone?.displayName, "UTC−03:30")
  }

  func testFixedTimeZoneRange() {
    XCTAssertEqual(FixedTimeZone.all.first?.displayName, "UTC−12:00")
    XCTAssertEqual(FixedTimeZone.all.last?.displayName, "UTC+14:00")
    XCTAssertEqual(FixedTimeZone.all.count, 105)
  }

  func testFixedTimeZoneAppliesToCalendars() {
    let originalTimeZone = NSTimeZone.default
    defer { NSTimeZone.default = originalTimeZone }

    NSTimeZone.default = FixedTimeZone(offsetSeconds: 8 * 60 * 60).timeZone
    XCTAssertEqual(Calendar.solar.timeZone.secondsFromGMT(), 8 * 60 * 60)
    XCTAssertEqual(Calendar.lunar.timeZone.secondsFromGMT(), 8 * 60 * 60)
  }
}

// MARK: - Private

private extension AppPreferences {
  enum Mocked {
    @Storage(key: "mocked.set-objects", defaultValue: Set())
    static var setObjects: Set<String>

    @Storage(key: "mocked.fixed-time-zone", defaultValue: nil)
    static var fixedTimeZone: FixedTimeZone?
  }
}
