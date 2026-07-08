import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TimelineView()
            }
            .tabItem {
                Label("Timeline", systemImage: "house.fill")
            }

            NavigationStack {
                ReviewComposerView()
            }
            .tabItem {
                Label("Review", systemImage: "plus.circle.fill")
            }

            NavigationStack {
                CurrentProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }

            NavigationStack {
                ConversationsView()
            }
            .tabItem {
                Label("Messages", systemImage: "message.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .tint(AppTheme.primary)
    }
}
