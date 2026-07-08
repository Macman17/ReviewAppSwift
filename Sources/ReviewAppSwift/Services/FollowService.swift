import Foundation

struct FollowService {
    private let client = SupabaseService.shared.client

    func follow(currentUserId: UUID, targetUserId: UUID) async throws {
        guard currentUserId != targetUserId else { throw ReviewAppError.invalidRecipient }
        try await client
            .from("follows")
            .insert(FollowInsert(followerId: currentUserId, followingId: targetUserId))
            .execute()
    }

    func unfollow(currentUserId: UUID, targetUserId: UUID) async throws {
        try await client
            .from("follows")
            .delete()
            .eq("follower_id", value: currentUserId.uuidString)
            .eq("following_id", value: targetUserId.uuidString)
            .execute()
    }

    func isFollowing(currentUserId: UUID, targetUserId: UUID) async throws -> Bool {
        let rows: [IDRow] = try await client
            .from("follows")
            .select("id")
            .eq("follower_id", value: currentUserId.uuidString)
            .eq("following_id", value: targetUserId.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.isEmpty == false
    }
}
