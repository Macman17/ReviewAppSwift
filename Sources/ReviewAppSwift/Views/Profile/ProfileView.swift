import SwiftUI

struct ProfileView: View {
    let userId: UUID
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ProfileHeader(viewModel: viewModel)

                Picker("Review type", selection: $viewModel.selectedType) {
                    ForEach(ReviewType.allCases) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectedType) { _ in
                    Task { await viewModel.reloadReviews() }
                }

                if viewModel.reviews.isEmpty {
                    EmptyState(icon: viewModel.selectedType.systemImage, title: "No reviews", subtitle: "Reviews for this profile will appear here.")
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
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem {
                Button {
                    Task { await viewModel.refresh(userId: userId) }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
