import Foundation

struct ReviewFeedItem: Identifiable, Codable, Equatable {
    let id: UUID
    let reviewerId: UUID
    let reviewedUserId: UUID
    let reviewType: ReviewType
    let rating: Int?
    let title: String?
    let content: String?
    let videoURL: String?
    let thumbnailURL: String?
    let duration: Int?
    let images: [String]?
    let likes: Int
    let comments: Int
    let views: Int
    let createdAt: String
    let updatedAt: String?
    let reviewerName: String?
    let reviewerUsername: String?
    let reviewerAvatarURL: String?
    let reviewedName: String?
    let reviewedUsername: String?

    enum CodingKeys: String, CodingKey {
        case id
        case reviewerId = "reviewer_id"
        case reviewedUserId = "reviewed_user_id"
        case reviewType = "review_type"
        case rating
        case title
        case content
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
        case duration
        case images
        case likes
        case comments
        case views
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reviewerName = "reviewer_name"
        case reviewerUsername = "reviewer_username"
        case reviewerAvatarURL = "reviewer_avatar_url"
        case reviewedName = "reviewed_name"
        case reviewedUsername = "reviewed_username"
    }

    var reviewerDisplayName: String {
        reviewerName.nilIfBlank ?? reviewerUsername.nilIfBlank ?? "Reviewer"
    }

    var reviewedDisplayName: String {
        reviewedName.nilIfBlank ?? reviewedUsername.nilIfBlank ?? "someone"
    }
}

struct ReviewInsert: Encodable {
    let reviewerId: UUID
    let reviewedUserId: UUID
    let reviewType: ReviewType
    let rating: Int?
    let title: String?
    let content: String?
    let videoURL: String?
    let thumbnailURL: String?
    let duration: Int?
    let images: [String]?

    enum CodingKeys: String, CodingKey {
        case reviewerId = "reviewer_id"
        case reviewedUserId = "reviewed_user_id"
        case reviewType = "review_type"
        case rating
        case title
        case content
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
        case duration
        case images
    }
}
