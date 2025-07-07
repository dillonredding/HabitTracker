import SwiftUI

struct StepButton: View {
    var icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 35)
                Image(systemName: icon)
            }
        }
    }
}
