import Foundation

enum ActivityError: Identifiable, LocalizedError {
    case duplicateTitle
    case missingTitle
    case negativeCompletions

    var id: String {
        self.errorDescription
    }

    var errorDescription: String {
        switch self {
        case .duplicateTitle:
            "An activity with that title already exists."
        case .missingTitle:
            "Title is required."
        case .negativeCompletions:
            "Completions must be greater than or equal to 0."
        }
    }
}
