import Foundation

enum MessageKind: String, Codable {
    case text
    case image
    case video
    case audio
}

struct Conversation: Identifiable, Codable, Equatable {
    let id: UUID
    let participant1Id: UUID
    let participant2Id: UUID
    let lastMessageAt: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case participant1Id = "participant1_id"
        case participant2Id = "participant2_id"
        case lastMessageAt = "last_message_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ConversationSummary: Identifiable, Codable, Equatable {
    let id: UUID
    let otherUserId: UUID
    let otherUserName: String?
    let otherUsername: String?
    let otherAvatarURL: String?
    let lastMessage: String?
    let lastMessageAt: String?
    let unreadCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case otherUserId = "other_user_id"
        case otherUserName = "other_user_name"
        case otherUsername = "other_username"
        case otherAvatarURL = "other_avatar_url"
        case lastMessage = "last_message"
        case lastMessageAt = "last_message_at"
        case unreadCount = "unread_count"
    }

    var displayName: String {
        otherUserName.nilIfBlank ?? otherUsername.nilIfBlank ?? "Conversation"
    }
}

struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    let conversationId: UUID
    let senderId: UUID
    let receiverId: UUID
    let content: String
    let messageType: MessageKind
    let mediaURL: String?
    let read: Bool
    let readAt: String?
    let createdAt: String
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case content
        case messageType = "message_type"
        case mediaURL = "media_url"
        case read
        case readAt = "read_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct MessageInsert: Encodable {
    let conversationId: UUID
    let senderId: UUID
    let receiverId: UUID
    let content: String
    let messageType: MessageKind
    let mediaURL: String?

    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case content
        case messageType = "message_type"
        case mediaURL = "media_url"
    }
}
