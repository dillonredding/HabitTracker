import Foundation

@Observable class ActivityStore {
    private static let key = "HabitTrackerActivities"

    var items: [Activity] {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(items) {
                UserDefaults.standard.set(data, forKey: ActivityStore.key)
            }
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: ActivityStore.key) {
            let decoder = JSONDecoder()
            if let items = try? decoder.decode([Activity].self, from: data) {
                self.items = items
                return
            }
        }
        self.items = []
    }

    func findOne(with id: UUID) -> Activity? {
        items.first(where: { $0.id == id })
    }

    func validate(_ activity: Activity) -> Result<Void, ActivityError> {
        if activity.title.isEmpty {
            return .failure(.missingTitle)
        }
        if activity.completions < 0 {
            return .failure(.negativeCompletions)
        }
        if items.contains(where: { $0.title == activity.title }) {
            return .failure(.duplicateTitle)
        }
        return .success(())
    }

    func append(_ activity: Activity) -> Result<Void, ActivityError> {
        let result = validate(activity)
        if case .success = result {
            items.append(activity)
        }
        return result
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func increment(_ id: UUID) {
        update(id) { $0.completions += 1 }
    }

    func decrement(_ id: UUID) {
        update(id) { $0.completions -= 1 }
    }

    private func update(_ id: UUID, with op: (inout Activity) -> Void) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        var item = items[index]
        op(&item)
        self.items[index] = item
    }
}
