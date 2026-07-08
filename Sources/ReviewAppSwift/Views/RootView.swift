import SwiftUI

struct RootView: View {
    @EnvironmentObject private var sessionStore: SessionStore

    var body: some View {
        Group {
            if sessionStore.isAuthenticated {
                MainTabView()
            } else {
                WelcomeAuthView()
            }
        }
        .task {
            await sessionStore.bootstrap()
        }
        .overlay {
            if sessionStore.isLoading {
                ZStack {
                    Color.black.opacity(0.25).ignoresSafeArea()
                    ProgressView()
                        .tint(.white)
                        .padding(24)
                        .background(AppTheme.elevated)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
        }
    }
}
