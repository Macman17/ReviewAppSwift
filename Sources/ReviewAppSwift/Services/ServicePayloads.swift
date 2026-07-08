import Foundation

struct IDRow: Decodable {
    let id: UUID
}

struct StoryInsert: Encodable {
    let userId: UUID
    let videoURL: String?
    let imageURL: String?
    let caption: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case videoURL = "video_url"
        case imageURL = "image_url"
        case caption
    }
}

struct MessageReadUpdate: Encodable {
    let read: Bool
    let readAt: String

    enum CodingKeys: String, CodingKey {
        case read
        case readAt = "read_at"
    }
}

enum Timestamp {
    static func now() -> String {
        ISO8601DateFormatter().string(from: Date())
    }
}
