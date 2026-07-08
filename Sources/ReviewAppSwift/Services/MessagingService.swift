import Foundation

struct MessagingService {
    private let client = SupabaseService.shared.client

    func conversationSummaries() async throws -> [ConversationSummary] {
        try await client
            .rpc("get_conversation_summaries")
            .execute()
            .value
    }

    func getOrCreateConversation(with otherUserId: UUID) async throws -> Conversation {
        let conversationId: UUID = try await client
            .rpc("get_or_create_conversation", params: ["other_user_id": otherUserId.uuidString])
            .execute()
            .value

        return try await client
            .from("conversations")
            .select()
            .eq("id", value: conversationId.uuidString)
            .single()
            .execute()
            .value
    }

    func messages(conversationId: UUID) async throws -> [Message] {
        try await client
            .from("messages")
            .select()
            .eq("conversation_id", value: conversationId.uuidString)
            .order("created_at", ascending: true)
            .execute()
            .value
    }

    func sendMessage(conversationId: UUID, senderId: UUID, receiverId: UUID, content: String) async throws -> Message {
        try await client
            .from("messages")
            .insert(
                MessageInsert(
                    conversationId: conversationId,
                    senderId: senderId,
                    receiverId: receiverId,
                    content: content,
                    messageType: .text,
                    mediaURL: nil
                )
            )
            .select()
            .single()
            .execute()
            .value
    }

    func markRead(conversationId: UUID, userId: UUID) async throws {
        try await client
            .from("messages")
            .update(MessageReadUpdate(read: true, readAt: Timestamp.now()))
            .eq("conversation_id", value: conversationId.uuidString)
            .eq("receiver_id", value: userId.uuidString)
            .eq("read", value: false)
            .execute()
    }
}
