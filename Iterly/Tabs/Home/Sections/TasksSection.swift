//
//  TasksSection.swift
//  Iterly
//
//  Created by Filippo Cilia on 25/02/2026.
//

import SwiftData
import SwiftUI

struct TasksSection: View {
    let tasks: [ProjectTask]?

    var body: some View {
        if let tasks, !tasks.isEmpty {
            VStack(alignment: .leading) {
                Text("Coming up tasks")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                ForEach(tasks) { task in
                    TaskRowView(task: task)
                }
            }
            .padding(.horizontal)
        }
    }

}

#Preview {
    NavigationStack {
        ScrollView {
            TasksSection(tasks: SampleData.makeProjects().flatMap { $0.tasks ?? [] })
        }
    }
    .modelContainer(SampleData.previewContainer)
}
