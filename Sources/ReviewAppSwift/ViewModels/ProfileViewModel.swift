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
    private var isUsingPlaceholderProfile = false

    func load(userId: UUID) async {
        isUsingPlaceholderProfile = false
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

    func refresh(userId: UUID) async {
        #if DEBUG
        if isUsingPlaceholderProfile {
            loadPlaceholderProfile()
            return
        }
        #endif

        await load(userId: userId)
    }

    func reloadReviews() async {
        guard let profile else { return }

        #if DEBUG
        if isUsingPlaceholderProfile {
            reviews = DevelopmentProfileFixture.reviews(for: selectedType)
            return
        }
        #endif

        do {
            reviews = try await reviewService.reviews(for: profile.id, type: selectedType)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func saveBio() async {
        guard let profile else { return }

        #if DEBUG
        if isUsingPlaceholderProfile {
            var updatedProfile = profile
            updatedProfile.bio = editedBio.nilIfBlank
            self.profile = updatedProfile
            return
        }
        #endif

        do {
            self.profile = try await profileService.updateProfile(
                id: profile.id,
                update: ProfileUpdate(bio: editedBio.nilIfBlank)
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    #if DEBUG
    func loadPlaceholderProfile() {
        isUsingPlaceholderProfile = true
        isLoading = false
        errorMessage = nil
        profile = DevelopmentProfileFixture.profile
        reviews = DevelopmentProfileFixture.reviews(for: selectedType)
        editedBio = DevelopmentProfileFixture.profile.bio ?? ""
    }
    #endif
}

#if DEBUG
enum DevelopmentProfileFixture {
    static let profileId = UUID(uuidString: "11111111-1111-4111-8111-111111111111")!
    static let reviewerId = UUID(uuidString: "22222222-2222-4222-8222-222222222222")!

    static let profile = Profile(
        id: profileId,
        username: "devprofile",
        name: "Jordan Sample",
        fullName: "Jordan Sample",
        avatarURL: nil,
        coverImage: nil,
        bio: "Building a review profile with thoughtful ratings, stories, and conversations. This placeholder lets the layout breathe before real account data exists.",
        showFollowers: true,
        isPublic: true,
        createdAt: isoString(daysAgo: 12),
        updatedAt: isoString(daysAgo: 1),
        followerCount: 128,
        followingCount: 42
    )

    static func reviews(for type: ReviewType) -> [ReviewFeedItem] {
        allReviews.filter { $0.reviewType == type }
    }

    private static let allReviews: [ReviewFeedItem] = [
        ReviewFeedItem(
            id: UUID(uuidString: "33333333-3333-4333-8333-333333333333")!,
            reviewerId: reviewerId,
            reviewedUserId: profileId,
            reviewType: .star,
            rating: 5,
            title: nil,
            content: "Jordan is thoughtful, quick to respond, and consistently brings sharp taste to every recommendation.",
            videoURL: nil,
            thumbnailURL: nil,
            duration: nil,
            images: nil,
            likes: 24,
            comments: 6,
            views: 0,
            createdAt: isoString(daysAgo: 1),
            updatedAt: nil,
            reviewerName: "Avery Lee",
            reviewerUsername: "averylee",
            reviewerAvatarURL: nil,
            reviewedName: "Jordan Sample",
            reviewedUsername: "devprofile"
        ),
        ReviewFeedItem(
            id: UUID(uuidString: "44444444-4444-4444-8444-444444444444")!,
            reviewerId: reviewerId,
            reviewedUserId: profileId,
            reviewType: .written,
            rating: nil,
            title: "A profile worth following",
            content: "The reviews feel personal without being noisy. Great balance of short ratings, longer notes, and a clear point of view.",
            videoURL: nil,
            thumbnailURL: nil,
            duration: nil,
            images: nil,
            likes: 18,
            comments: 3,
            views: 0,
            createdAt: isoString(daysAgo: 3),
            updatedAt: nil,
            reviewerName: "Mina Patel",
            reviewerUsername: "minapatel",
            reviewerAvatarURL: nil,
            reviewedName: "Jordan Sample",
            reviewedUsername: "devprofile"
        ),
        ReviewFeedItem(
            id: UUID(uuidString: "55555555-5555-4555-8555-555555555555")!,
            reviewerId: reviewerId,
            reviewedUserId: profileId,
            reviewType: .video,
            rating: nil,
            title: "Quick video reaction",
            content: nil,
            videoURL: nil,
            thumbnailURL: nil,
            duration: 42,
            images: nil,
            likes: 31,
            comments: 9,
            views: 214,
            createdAt: isoString(daysAgo: 5),
            updatedAt: nil,
            reviewerName: "Chris Morgan",
            reviewerUsername: "chrismorgan",
            reviewerAvatarURL: nil,
            reviewedName: "Jordan Sample",
            reviewedUsername: "devprofile"
        )
    ]

    private static func isoString(daysAgo: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        return ISO8601DateFormatter().string(from: date)
    }
}
#endif
