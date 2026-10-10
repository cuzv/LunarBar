//
//  FixedTimeZone.swift
//  LunarBarMac
//

import Foundation

struct FixedTimeZone: Codable, Equatable, Identifiable {
  static let all = stride(
    from: Constants.minimumOffset,
    through: Constants.maximumOffset,
    by: Constants.offsetStep
  ).map(Self.init(offsetSeconds:))

  let offsetSeconds: Int

  var id: Int {
    offsetSeconds
  }

  var timeZone: TimeZone {
    TimeZone(secondsFromGMT: offsetSeconds) ?? .gmt
  }

  var displayName: String {
    let sign = offsetSeconds < 0 ? "−" : "+"
    let absoluteMinutes = abs(offsetSeconds) / 60
    return String(format: "UTC%@%02d:%02d", sign, absoluteMinutes / 60, absoluteMinutes % 60)
  }

  private enum Constants {
    static let minimumOffset = -12 * 60 * 60
    static let maximumOffset = 14 * 60 * 60
    static let offsetStep = 15 * 60
  }
}
