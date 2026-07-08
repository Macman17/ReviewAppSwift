import SwiftUI

struct ReviewComposerView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = ReviewComposerViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Picker("Review type", selection: $viewModel.type) {
                    ForEach(ReviewType.allCases) { type in
                        Label(type.title, systemImage: type.systemImage).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                PeoplePicker(selectedProfile: $viewModel.selectedProfile)

                if viewModel.type == .star {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rating")
                            .font(.headline)
                            .foregroundStyle(AppTheme.text)
                        StarPicker(rating: $viewModel.rating)
                    }
                }

                if viewModel.type != .star {
                    TextField("Title", text: $viewModel.title)
                        .textFieldStyle(.roundedBorder)
                }

                if viewModel.type == .video {
                    TextField("Video URL", text: $viewModel.videoURL)
                        .textFieldStyle(.roundedBorder)

                    TextField("Thumbnail URL", text: $viewModel.thumbnailURL)
                        .textFieldStyle(.roundedBorder)

                    TextField("Duration seconds", text: $viewModel.duration)
                        .textFieldStyle(.roundedBorder)
                }

                TextField(
                    viewModel.type == .star ? "Description" : "Review",
                    text: $viewModel.body,
                    axis: .vertical
                )
                .lineLimit(4...8)
                .textFieldStyle(.roundedBorder)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.primary)
                }

                if let posted = viewModel.postedReview {
                    Text("Posted \(posted.reviewType.title.lowercased()) review.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.secondary)
                }

                Button {
                    guard let userId = sessionStore.user?.id else { return }
                    Task {
                        await viewModel.submit(currentUserId: userId)
                    }
                } label: {
                    Label("Post Review", systemImage: "paperplane.fill")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.primary)
                .disabled(viewModel.isPosting)
            }
            .padding(16)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("New Review")
    }
}
