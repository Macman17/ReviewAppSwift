import SwiftUI

struct ConversationsView: View {
    @StateObject private var viewModel = ConversationsViewModel()

    var body: some View {
        List {
            if viewModel.conversations.isEmpty && !viewModel.isLoading {
                EmptyState(icon: "message", title: "No messages", subtitle: "Start a chat from search or a profile.")
                    .listRowBackground(Color.clear)
            }

            ForEach(viewModel.conversations) { conversation in
                NavigationLink {
                    ChatScreen(summary: conversation)
                } label: {
                    ConversationRow(conversation: conversation)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Messages")
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
