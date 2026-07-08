import Foundation

struct Profile: Identifiable, Codable, Equatable {
    let id: UUID
    var username: String?
    var name: String?
    var fullName: String?
    var avatarURL: String?
    var coverImage: String?
    var bio: String?
    var showFollowers: Bool?
    var isPublic: Bool?
    var createdAt: String?
    var updatedAt: String?
    var followerCount: Int?
    var followingCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case fullName = "full_name"
        case avatarURL = "avatar_url"
        case coverImage = "cover_image"
        case bio
        case showFollowers = "show_followers"
        case isPublic = "is_public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case followerCount = "follower_count"
        case followingCount = "following_count"
    }

    var displayName: String {
        name.nilIfBlank ?? fullName.nilIfBlank ?? username.nilIfBlank ?? "Unknown"
    }

    var handle: String {
        guard let username = username.nilIfBlank else { return "@user" }
        return "@\(username)"
    }
}

struct ProfileUpdate: Encodable {
    var username: String? = nil
    var name: String? = nil
    var fullName: String? = nil
    var avatarURL: String? = nil
    var coverImage: String? = nil
    var bio: String? = nil
    var showFollowers: Bool? = nil
    var isPublic: Bool? = nil

    enum CodingKeys: String, CodingKey {
        case username
        case name
        case fullName = "full_name"
        case avatarURL = "avatar_url"
        case coverImage = "cover_image"
        case bio
        case showFollowers = "show_followers"
        case isPublic = "is_public"
    }
}
