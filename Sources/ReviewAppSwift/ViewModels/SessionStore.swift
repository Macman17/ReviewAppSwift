import Foundation
import Supabase
import SwiftUI

@MainActor
final class SessionStore: ObservableObject {
    @Published var session: Session?
    @Published var user: User?
    @Published var profile: Profile?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService = AuthService()
    private let profileService = ProfileService()

    var isAuthenticated: Bool {
        user != nil
    }

    func bootstrap() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        if let current = authService.currentSession {
            session = current
            user = current.user
            await loadProfile()
            return
        }

        do {
            let restored = try await authService.session()
            session = restored
            user = restored.user
            await loadProfile()
        } catch {
            session = nil
            user = nil
            profile = nil
        }
    }

    func signIn(email: String, password: String) async {
        await performAuthAction {
            try await authService.signIn(email: email, password: password)
            try await refreshSession()
        }
    }

    func signUp(email: String, password: String, username: String?, name: String?) async {
        await performAuthAction {
            try await authService.signUp(email: email, password: password, username: username, name: name)
            try await refreshSession()
        }
    }

    func signOut() async {
        await performAuthAction {
            try await authService.signOut()
            session = nil
            user = nil
            profile = nil
        }
    }

    func loadProfile() async {
        guard user != nil else { return }

        do {
            var currentProfile = try await profileService.fetchCurrentProfile()
            if let id = user?.id {
                currentProfile.followerCount = try? await profileService.followerCount(for: id)
                currentProfile.followingCount = try? await profileService.followingCount(for: id)
            }
            profile = currentProfile
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func refreshSession() async throws {
        let restored = try await authService.session()
        session = restored
        user = restored.user
        await loadProfile()
    }

    private func performAuthAction(_ action: () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await action()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
