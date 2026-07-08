import Foundation

struct ReviewService {
    private let client = SupabaseService.shared.client

    func timeline(limit: Int = 50) async throws -> [ReviewFeedItem] {
        try await client
            .from("review_feed")
            .select()
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    func reviews(for userId: UUID, type: ReviewType? = nil) async throws -> [ReviewFeedItem] {
        if let type {
            return try await client
                .from("review_feed")
                .select()
                .eq("reviewed_user_id", value: userId.uuidString)
                .eq("review_type", value: type.rawValue)
                .order("created_at", ascending: false)
                .execute()
                .value
        }

        return try await client
            .from("review_feed")
            .select()
            .eq("reviewed_user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func createReview(_ review: ReviewInsert) async throws -> ReviewFeedItem {
        guard review.reviewerId != review.reviewedUserId else { throw ReviewAppError.invalidRecipient }

        let row: IDRow = try await client
            .from("reviews")
            .insert(review)
            .select("id")
            .single()
            .execute()
            .value

        return try await fetchReview(id: row.id)
    }

    func fetchReview(id: UUID) async throws -> ReviewFeedItem {
        try await client
            .from("review_feed")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }
}
