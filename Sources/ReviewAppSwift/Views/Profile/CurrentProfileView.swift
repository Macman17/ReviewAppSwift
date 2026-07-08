import SwiftUI

struct CurrentProfileView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        Group {
            if let userId = sessionStore.user?.id {
                ProfileView(userId: userId, viewModel: viewModel)
            } else {
                EmptyState(icon: "person.crop.circle.badge.exclamationmark", title: "No profile", subtitle: "Sign in again to load your profile.")
                    .background(AppTheme.background)
            }
        }
        .task(id: sessionStore.user?.id) {
            if let userId = sessionStore.user?.id {
                await viewModel.load(userId: userId)
            }
        }
    }
}

#if DEBUG
struct DevelopmentProfilePreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ProfileView(userId: DevelopmentProfileFixture.profileId, viewModel: viewModel)
                .task {
                    viewModel.loadPlaceholderProfile()
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
#endif
