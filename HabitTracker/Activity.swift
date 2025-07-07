import Foundation

struct Activity: Codable, Hashable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var completions = 0
}

extension Activity {
    static let example = Activity(
        title: "Foobar",
        description: "Lorem ipsum dolor sit amet."
    )
}
