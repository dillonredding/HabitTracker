import SwiftUI

struct AddActivityView: View {
    @Environment(ActivityStore.self) var store
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""

    @State private var error: ActivityError?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description, axis: .vertical)
            }
            .scrollContentBackground(.hidden)
            .background(.darkBackground)
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let result = store.append(
                            Activity(
                                title: title,
                                description: description
                            )
                        )
                        if case .failure(let error) = result {
                            self.error = error
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            .alert(item: $error) {
                Alert(
                    title: Text("\($0.errorDescription)")
                )
            }
        }
    }
}

#Preview {
    let store = ActivityStore()
    let _ = store.append(Activity.example)
    AddActivityView()
        .preferredColorScheme(.dark)
        .environment(store)
}
