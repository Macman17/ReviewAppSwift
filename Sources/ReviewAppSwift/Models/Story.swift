import Foundation

struct Story: Identifiable, Codable, Equatable {
    let id: UUID
    let userId: UUID
    let videoURL: String?
    let imageURL: String?
    let caption: String?
    let views: Int
    let expiresAt: String
    let createdAt: String
    let userName: String?
    let userAvatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case videoURL = "video_url"
        case imageURL = "image_url"
        case caption
        case views
        case expiresAt = "expires_at"
        case createdAt = "created_at"
        case userName = "user_name"
        case userAvatarURL = "user_avatar_url"
    }
}
