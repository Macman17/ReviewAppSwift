import SwiftUI

struct TimelineView: View {
    @StateObject private var viewModel = TimelineViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                StoryStrip(stories: viewModel.stories)

                if viewModel.isLoading && viewModel.reviews.isEmpty {
                    ProgressView()
                        .tint(.white)
                        .padding(.top, 48)
                } else if viewModel.reviews.isEmpty {
                    EmptyState(
                        icon: "star.bubble",
                        title: "No reviews yet",
                        subtitle: "New Supabase-backed reviews will appear here."
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.reviews) { review in
                            ReviewFeedCard(review: review)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Timeline")
        .toolbar {
            ToolbarItem {
                Button {
                    Task { await viewModel.load() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
