import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var reviews: [ReviewFeedItem] = []
    @Published var selectedType: ReviewType = .star
    @Published var editedBio = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let profileService = ProfileService()
    private let reviewService = ReviewService()

    func load(userId: UUID) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let loadedProfile = profileService.fetchProfile(id: userId)
            async let loadedReviews = reviewService.reviews(for: userId, type: selectedType)

            var hydratedProfile = try await loadedProfile
            hydratedProfile.followerCount = try? await profileService.followerCount(for: userId)
            hydratedProfile.followingCount = try? await profileService.followingCount(for: userId)
            profile = hydratedProfile
            reviews = try await loadedReviews
            editedBio = hydratedProfile.bio ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func reloadReviews() async {
        guard let profile else { return }
        do {
            reviews = try await reviewService.reviews(for: profile.id, type: selectedType)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveBio() async {
        guard let profile else { return }

        do {
            self.profile = try await profileService.updateProfile(
                id: profile.id,
                update: ProfileUpdate(bio: editedBio.nilIfBlank)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
