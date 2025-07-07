import SwiftUI

struct ContentView: View {
    @Environment(ActivityStore.self) var store

    @State private var showNewActivitySheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.items) { activity in
                    NavigationLink(value: activity) {
                        HStack {
                            Text(activity.title)
                                .font(.headline)
                            Spacer()
                            Text("\(activity.completions)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listRowBackground(Color.darkBackground)
                }
                .onDelete {
                    store.remove(at: $0)
                }
            }
            .listStyle(.plain)
            .background(.darkBackground)
            .navigationTitle("HabitTracker")
            .navigationDestination(for: Activity.self) { activity in
                ActivityView(activityId: activity.id)
            }
            .toolbar {
                Button("Add Activity", systemImage: "plus") {
                    showNewActivitySheet = true
                }
            }
            .sheet(isPresented: $showNewActivitySheet) {
                AddActivityView()
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .environment(ActivityStore())
}
