import Foundation

enum ReviewAppError: LocalizedError {
    case notAuthenticated
    case missingProfile
    case invalidReview
    case invalidRecipient

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You need to be signed in."
        case .missingProfile:
            return "Your profile could not be loaded."
        case .invalidReview:
            return "Finish the required review fields before posting."
        case .invalidRecipient:
            return "Choose a different person."
        }
    }
}
