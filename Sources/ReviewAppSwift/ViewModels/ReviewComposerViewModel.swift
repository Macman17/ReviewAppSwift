import Foundation
import SwiftUI

@MainActor
final class ReviewComposerViewModel: ObservableObject {
    @Published var type: ReviewType = .star
    @Published var rating = 0
    @Published var title = ""
    @Published var body = ""
    @Published var videoURL = ""
    @Published var thumbnailURL = ""
    @Published var duration = "300"
    @Published var selectedProfile: Profile?
    @Published var postedReview: ReviewFeedItem?
    @Published var errorMessage: String?
    @Published var isPosting = false

    private let reviewService = ReviewService()

    func submit(currentUserId: UUID) async {
        guard let selectedProfile else {
            errorMessage = "Choose someone to review."
            return
        }

        guard selectedProfile.id != currentUserId else {
            errorMessage = "You cannot review yourself."
            return
        }

        let insert: ReviewInsert
        switch type {
        case .star:
            guard rating > 0 else {
                errorMessage = "Choose a rating."
                return
            }
            insert = ReviewInsert(
                reviewerId: currentUserId,
                reviewedUserId: selectedProfile.id,
                reviewType: .star,
                rating: rating,
                title: nil,
                content: body.nilIfBlank,
                videoURL: nil,
                thumbnailURL: nil,
                duration: nil,
                images: nil
            )
        case .written:
            guard title.nilIfBlank != nil, body.nilIfBlank != nil else {
                errorMessage = "Add a title and review."
                return
            }
            insert = ReviewInsert(
                reviewerId: currentUserId,
                reviewedUserId: selectedProfile.id,
                reviewType: .written,
                rating: nil,
                title: title.nilIfBlank,
                content: body.nilIfBlank,
                videoURL: nil,
                thumbnailURL: nil,
                duration: nil,
                images: nil
            )
        case .video:
            guard title.nilIfBlank != nil, videoURL.nilIfBlank != nil else {
                errorMessage = "Add a title and video URL."
                return
            }
            insert = ReviewInsert(
                reviewerId: currentUserId,
                reviewedUserId: selectedProfile.id,
                reviewType: .video,
                rating: nil,
                title: title.nilIfBlank,
                content: body.nilIfBlank,
                videoURL: videoURL.nilIfBlank,
                thumbnailURL: thumbnailURL.nilIfBlank,
                duration: Int(duration) ?? 300,
                images: nil
            )
        }

        isPosting = true
        errorMessage = nil
        defer { isPosting = false }

        do {
            postedReview = try await reviewService.createReview(insert)
            resetForm(keeping: selectedProfile)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetForm(keeping selectedProfile: Profile) {
        rating = 0
        title = ""
        body = ""
        videoURL = ""
        thumbnailURL = ""
        duration = "300"
        self.selectedProfile = selectedProfile
    }
}
