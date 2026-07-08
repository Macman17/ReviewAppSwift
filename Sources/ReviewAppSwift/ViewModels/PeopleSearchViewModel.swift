import Foundation
import SwiftUI

@MainActor
final class PeopleSearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Profile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let profileService = ProfileService()

    func search() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            results = try await profileService.searchProfiles(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
