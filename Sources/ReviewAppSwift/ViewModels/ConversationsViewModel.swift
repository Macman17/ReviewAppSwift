import Foundation
import SwiftUI

@MainActor
final class ConversationsViewModel: ObservableObject {
    @Published var conversations: [ConversationSummary] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let messagingService = MessagingService()

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            conversations = try await messagingService.conversationSummaries()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
