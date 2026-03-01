import SwiftUI

struct ProjectPlaceholderView: View {
    let projectID: Int

    var body: some View {
        Text("Project \(projectID)")
            .navigationTitle("Project")
    }
}

#Preview {
    NavigationStack {
        ProjectPlaceholderView(projectID: 1)
    }
}
