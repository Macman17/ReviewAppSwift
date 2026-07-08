import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var sessionStore: SessionStore

    var body: some View {
        List {
            Section("Account") {
                HStack {
                    AvatarView(urlString: sessionStore.profile?.avatarURL, size: 42)
                    VStack(alignment: .leading) {
                        Text(sessionStore.profile?.displayName ?? "ReviewApp user")
                        Text(sessionStore.profile?.handle ?? "")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Button(role: .destructive) {
                    Task { await sessionStore.signOut() }
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }

            Section("Backend") {
                Label("Supabase Auth", systemImage: "checkmark.seal.fill")
                Label("Postgres profiles and reviews", systemImage: "tablecells.fill")
                Label("Realtime-ready messaging", systemImage: "bolt.horizontal.circle.fill")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Settings")
    }
}
