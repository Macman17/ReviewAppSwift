import Foundation

struct NotificationService {
    private let client = SupabaseService.shared.client

    func notifications(for userId: UUID) async throws -> [NotificationRow] {
        try await client
            .from("notifications")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func markRead(id: UUID) async throws {
        try await client
            .from("notifications")
            .update(["read": true])
            .eq("id", value: id.uuidString)
            .execute()
    }
}
