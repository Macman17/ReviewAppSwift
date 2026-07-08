import SwiftUI

struct ProfileHeader: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: viewModel.profile?.coverImage ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    LinearGradient(
                        colors: [AppTheme.primary.opacity(0.65), AppTheme.secondary.opacity(0.55)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                AvatarView(urlString: viewModel.profile?.avatarURL, size: 92)
                    .overlay {
                        Circle().stroke(.black, lineWidth: 4)
                    }
                    .offset(x: 14, y: 36)
            }
            .padding(.bottom, 36)

            Text(viewModel.profile?.displayName ?? "Profile")
                .font(.title2.bold())
                .foregroundStyle(AppTheme.text)

            Text(viewModel.profile?.handle ?? "@user")
                .foregroundStyle(AppTheme.muted)

            HStack(spacing: 22) {
                StatBlock(value: viewModel.profile?.followerCount ?? 0, label: "Followers")
                StatBlock(value: viewModel.profile?.followingCount ?? 0, label: "Following")
                StatBlock(value: viewModel.reviews.count, label: "Reviews")
            }

            Text(viewModel.profile?.bio.nilIfBlank ?? "No bio yet.")
                .foregroundStyle(AppTheme.text)

            DisclosureGroup {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Bio", text: $viewModel.editedBio, axis: .vertical)
                        .lineLimit(3...5)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        Task { await viewModel.saveBio() }
                    } label: {
                        Label("Save Bio", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.primary)
                }
                .padding(.top, 10)
            } label: {
                Label("Edit Profile", systemImage: "pencil")
                    .foregroundStyle(AppTheme.text)
            }
        }
        .appCard()
    }
}
