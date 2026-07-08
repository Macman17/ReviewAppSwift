import Foundation

struct FollowInsert: Encodable {
    let followerId: UUID
    let followingId: UUID

    enum CodingKeys: String, CodingKey {
        case followerId = "follower_id"
        case followingId = "following_id"
    }
}

struct NotificationRow: Identifiable, Codable, Equatable {
    let id: UUID
    let userId: UUID
    let type: String
    let title: String
    let message: String
    let read: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type
        case title
        case message
        case read
        case createdAt = "created_at"
    }
}
