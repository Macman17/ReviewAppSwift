import Supabase

struct AuthService {
    private let client = SupabaseService.shared.client

    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }

    func signUp(email: String, password: String, username: String?, name: String?) async throws {
        var metadata: [String: AnyJSON] = [:]

        if let username = username.nilIfBlank {
            metadata["username"] = .string(username)
        }

        if let name = name.nilIfBlank {
            metadata["name"] = .string(name)
            metadata["full_name"] = .string(name)
        }

        if metadata.isEmpty {
            try await client.auth.signUp(email: email, password: password)
        } else {
            try await client.auth.signUp(email: email, password: password, data: metadata)
        }
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    func session() async throws -> Session {
        try await client.auth.session
    }

    var currentSession: Session? {
        client.auth.currentSession
    }

    var currentUser: User? {
        client.auth.currentUser
    }
}
