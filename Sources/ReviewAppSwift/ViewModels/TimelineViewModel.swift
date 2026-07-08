import Foundation
import SwiftUI

@MainActor
final class TimelineViewModel: ObservableObject {
    @Published var reviews: [ReviewFeedItem] = []
    @Published var stories: [Story] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let reviewService = ReviewService()
    private let storiesService = StoriesService()

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let reviewItems = reviewService.timeline()
            async let storyItems = storiesService.activeStories()
            reviews = try await reviewItems
            stories = try await storyItems
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
