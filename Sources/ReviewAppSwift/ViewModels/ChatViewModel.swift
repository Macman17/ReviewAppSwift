import Foundation
import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var conversation: Conversation?
    @Published var messages: [Message] = []
    @Published var draft = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let messagingService = MessagingService()

    func open(with otherUserId: UUID, currentUserId: UUID) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            conversation = try await messagingService.getOrCreateConversation(with: otherUserId)
            if let conversation {
                messages = try await messagingService.messages(conversationId: conversation.id)
                try await messagingService.markRead(conversationId: conversation.id, userId: currentUserId)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func send(currentUserId: UUID) async {
        guard let conversation, let content = draft.nilIfBlank else { return }

        let receiverId = conversation.participant1Id == currentUserId
            ? conversation.participant2Id
            : conversation.participant1Id

        do {
            let message = try await messagingService.sendMessage(
                conversationId: conversation.id,
                senderId: currentUserId,
                receiverId: receiverId,
                content: content
            )
            messages.append(message)
            draft = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
