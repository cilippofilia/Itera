//
//  TaskDetailView.swift
//  Iterly
//
//  Created by Filippo Cilia on 25/02/2026.
//

import SwiftUI

struct TaskDetailView: View {
    let task: ProjectTask

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primary)

                if let details = task.details, !details.isEmpty {
                    Text(details)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }

                GroupBox("Info") {
                    LabeledContent("Status") {
                        Text(task.status.title)
                    }

                    LabeledContent("Priority", value: task.priority.title)

                    if let startDate = task.startDate {
                        LabeledContent("Start Date") {
                            Text(startDate, format: .dateTime.month().day().year())
                        }
                    }

                    if let dueDate = task.dueDate {
                        LabeledContent("Due Date") {
                            Text(dueDate, format: .dateTime.month().day().year())
                        }
                    }

                    LabeledContent("Created") {
                        Text(task.creationDate, format: .dateTime.month().day().year())
                    }

                    if let projectTitle = task.project?.title {
                        LabeledContent("Project", value: projectTitle)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private func statusBadgeColor(for status: TaskStatus) -> Color {
        switch status {
        case .inProgress:
            return .yellow
        case .done:
            return .green
        case .notStarted:
            return .secondary
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: SampleData.makeProjects()[0].tasks?[0] ?? ProjectTask(title: "Test task"))
    }
}
