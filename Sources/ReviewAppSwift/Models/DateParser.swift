import Foundation

enum DateParser {
    static func date(from value: String?) -> Date? {
        guard let value else { return nil }

        let fractional: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()

        let basic: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            return formatter
        }()

        return fractional.date(from: value) ?? basic.date(from: value)
    }

    static func relative(_ value: String?) -> String {
        guard let date = date(from: value) else { return "" }
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 { return "now" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes)m" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h" }
        let days = hours / 24
        if days < 7 { return "\(days)d" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
