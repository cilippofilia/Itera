import SwiftUI

struct TaskPlaceholderView: View {
    let taskID: Int

    var body: some View {
        Text("Task \(taskID)")
            .navigationTitle("Task")
    }
}

#Preview {
    NavigationStack {
        TaskPlaceholderView(taskID: 1)
    }
}
