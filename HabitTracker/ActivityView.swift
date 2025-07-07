import SwiftUI

struct ActivityView: View {
    var activityId: UUID

    @Environment(ActivityStore.self) var store

    var activity: Activity {
        guard let activity = store.findOne(with: activityId) else {
            fatalError("Activity \(activityId) not found. How did this happened?!")
        }
        return activity
    }

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text(activity.description)

                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackground)
                        .padding(.vertical)

                    Text("Completions")
                        .font(.title.bold())
                        .padding(.bottom)
                }

                HStack {
                    StepButton(icon: "minus") {
                        store.decrement(activityId)
                    }
                    .disabled(activity.completions <= 0)

                    Text("\(activity.completions)")
                        .font(.largeTitle)
                        .frame(minWidth: 64)

                    StepButton(icon: "plus") {
                        store.increment(activityId)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.darkBackground)
        .navigationTitle(activity.title)
    }
}

#Preview {
    let store = ActivityStore()
    let activity = store.items.first(where: { $0.title == Activity.example.title }) ?? Activity.example
    NavigationStack {
        ActivityView(activityId: activity.id)
    }
    .preferredColorScheme(.dark)
    .environment(store)
}
