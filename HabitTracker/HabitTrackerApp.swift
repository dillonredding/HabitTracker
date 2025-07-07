import SwiftUI

@main
struct HabitTrackerApp: App {
    let activityStore = ActivityStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(activityStore)
        }
    }
}
