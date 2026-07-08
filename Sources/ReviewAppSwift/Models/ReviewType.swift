import Foundation

enum ReviewType: String, CaseIterable, Codable, Identifiable {
    case star
    case written
    case video

    var id: String { rawValue }

    var title: String {
        switch self {
        case .star: return "Star"
        case .written: return "Written"
        case .video: return "Video"
        }
    }

    var systemImage: String {
        switch self {
        case .star: return "star.fill"
        case .written: return "pencil"
        case .video: return "play.rectangle.fill"
        }
    }
}
