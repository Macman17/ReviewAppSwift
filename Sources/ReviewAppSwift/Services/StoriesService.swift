import Foundation

struct StoriesService {
    private let client = SupabaseService.shared.client

    func activeStories(limit: Int = 40) async throws -> [Story] {
        try await client
            .from("story_feed")
            .select()
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    func createStory(userId: UUID, videoURL: String?, imageURL: String?, caption: String?) async throws -> Story {
        let row: IDRow = try await client
            .from("stories")
            .insert(StoryInsert(userId: userId, videoURL: videoURL, imageURL: imageURL, caption: caption))
            .select("id")
            .single()
            .execute()
            .value

        return try await client
            .from("story_feed")
            .select()
            .eq("id", value: row.id.uuidString)
            .single()
            .execute()
            .value
    }

    func markViewed(storyId: UUID, viewerId: UUID) async throws {
        try await client
            .rpc("mark_story_viewed", params: [
                "story_id": storyId.uuidString,
                "viewer_id": viewerId.uuidString
            ])
            .execute()
    }
}
