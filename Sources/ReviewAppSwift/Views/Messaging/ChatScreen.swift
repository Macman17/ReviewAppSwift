import SwiftUI

struct ChatScreen: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = ChatViewModel()
    let summary: ConversationSummary

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, isOwn: message.senderId == sessionStore.user?.id)
                                .id(message.id)
                        }
                    }
                    .padding(14)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider().background(AppTheme.divider)

            HStack(spacing: 10) {
                TextField("Message", text: $viewModel.draft, axis: .vertical)
                    .lineLimit(1...4)
                    .textFieldStyle(.roundedBorder)

                Button {
                    guard let userId = sessionStore.user?.id else { return }
                    Task { await viewModel.send(currentUserId: userId) }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.primary)
                .disabled(viewModel.draft.nilIfBlank == nil)
            }
            .padding(12)
            .background(AppTheme.elevated)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(summary.displayName)
        .task {
            if let userId = sessionStore.user?.id {
                await viewModel.open(with: summary.otherUserId, currentUserId: userId)
            }
        }
    }
}
