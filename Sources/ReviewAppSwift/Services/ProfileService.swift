import Foundation

struct ProfileService {
    private let client = SupabaseService.shared.client

    func fetchProfile(id: UUID) async throws -> Profile {
        try await client
            .from("profiles")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    func fetchCurrentProfile() async throws -> Profile {
        guard let id = client.auth.currentUser?.id else { throw ReviewAppError.notAuthenticated }
        return try await fetchProfile(id: id)
    }

    func searchProfiles(query: String, limit: Int = 20) async throws -> [Profile] {
        let cleaned = query
            .replacingOccurrences(of: ",", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else { return [] }

        return try await client
            .from("profiles")
            .select()
            .or("username.ilike.%\(cleaned)%,name.ilike.%\(cleaned)%,full_name.ilike.%\(cleaned)%")
            .limit(limit)
            .execute()
            .value
    }

    func updateProfile(id: UUID, update: ProfileUpdate) async throws -> Profile {
        try await client
            .from("profiles")
            .update(update)
            .eq("id", value: id.uuidString)
            .select()
            .single()
            .execute()
            .value
    }

    func followerCount(for userId: UUID) async throws -> Int {
        try await client
            .from("follows")
            .select("id", head: true, count: .exact)
            .eq("following_id", value: userId.uuidString)
            .execute()
            .count ?? 0
    }

    func followingCount(for userId: UUID) async throws -> Int {
        try await client
            .from("follows")
            .select("id", head: true, count: .exact)
            .eq("follower_id", value: userId.uuidString)
            .execute()
            .count ?? 0
    }
}
