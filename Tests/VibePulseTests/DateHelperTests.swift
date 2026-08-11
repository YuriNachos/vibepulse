import XCTest

@testable import VibePulse

final class DateHelperTests: XCTestCase {
  func testDateKeyRoundTrip() {
    let calendar = Calendar.current
    let date = calendar.date(
      from: DateComponents(year: 2024, month: 1, day: 15, hour: 12, minute: 34))!
    let key = DateHelper.dateKey(for: date)
    let parsed = DateHelper.date(fromKey: key)
    XCTAssertNotNil(parsed)
    if let parsed {
      XCTAssertEqual(DateHelper.dateKey(for: parsed), key)
    }
  }

  func testNormalizedDateKeyAcceptsCanonicalAndTextualDates() {
    XCTAssertEqual(DateHelper.normalizedDateKey(from: "2026-07-15"), "2026-07-15")
    XCTAssertEqual(DateHelper.normalizedDateKey(from: "2024-02-29"), "2024-02-29")
    XCTAssertEqual(DateHelper.normalizedDateKey(from: "July 2, 2026"), "2026-07-02")
    XCTAssertEqual(DateHelper.normalizedDateKey(from: "2026/07/15"), "2026-07-15")
  }

  func testNormalizedDateKeyRejectsInvalidCalendarDates() {
    // February never has a 30th, and 2026 is not a leap year.
    XCTAssertNil(DateHelper.normalizedDateKey(from: "2026-02-30"))
    XCTAssertNil(DateHelper.normalizedDateKey(from: "2026-02-29"))
    XCTAssertNil(DateHelper.normalizedDateKey(from: "2026-13-01"))
  }
}
