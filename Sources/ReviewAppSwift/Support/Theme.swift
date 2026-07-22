import SwiftUI

enum AppResources {
    static var bundle: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        return .main
        #endif
    }
}

enum AppTheme {
    static let background = Color(red: 0.04, green: 0.04, blue: 0.05)
    static let elevated = Color(red: 0.10, green: 0.10, blue: 0.12)
    static let elevatedSoft = Color(red: 0.15, green: 0.15, blue: 0.18)
    static let primary = Color(red: 1.0, green: 0.42, blue: 0.42)
    static let secondary = Color(red: 0.63, green: 0.74, blue: 0.90)
    static let text = Color.white
    static let muted = Color(red: 0.68, green: 0.68, blue: 0.72)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.16)
    static let divider = Color.white.opacity(0.10)
}

extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

extension Optional where Wrapped == String {
    var nilIfBlank: String? {
        switch self {
        case .some(let value):
            return value.nilIfBlank
        case .none:
            return nil
        }
    }
}

extension View {
    func appCard() -> some View {
        padding(14)
            .background(AppTheme.elevated)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
