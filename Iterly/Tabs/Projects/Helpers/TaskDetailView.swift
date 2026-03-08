//
//  TaskDetailView.swift
//  Iterly
//
//  Created by Filippo Cilia on 25/02/2026.
//

import SwiftData
import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var taskToEdit: ProjectTask?
    let task: ProjectTask

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)

                if let details = task.details, !details.isEmpty {
                    Text(details)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }

                VStack(alignment: .leading) {
                    Text("Info")
                        .bold()
                        .padding([.horizontal, .top])

                    LabeledContent("Status") {
                        Menu {
                            Picker("Status", selection: Binding(
                                get: { task.status },
                                set: {
                                    task.status = $0
                                    task.project.touch()
                                }
                            )) {
                                ForEach(TaskStatus.allCases, id: \.self) { status in
                                    Text(status.title)
                                        .tag(status)
                                }
                            }
                        } label: {
                            Text(task.status.title)
                                .badgeStyle(backgroundColor: task.status.backgroundColor)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)

                    LabeledContent("Priority") {
                        Menu {
                            Picker("Priority", selection: Binding(
                                get: { task.priority },
                                set: {
                                    task.priority = $0
                                    task.project.touch()
                                }
                            )) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    Text(priority.title)
                                        .tag(priority)
                                }
                            }
                        } label: {
                            Text(task.priority.title)
                                .badgeStyle(backgroundColor: task.priority.backgroundColor)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)

                    DatePicker(
                        "Due Date",
                        selection: Binding(
                            get: { task.dueDate },
                            set: {
                                task.dueDate = $0
                                task.project.touch()
                            }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                    if let overdueDays {
                        Text(
                            String.localizedStringWithFormat(
                                NSLocalizedString("overdue_days", comment: "Overdue days label"),
                                overdueDays
                            )
                        )
                        .foregroundStyle(.red)
                        .bold()
                        .padding([.horizontal, .bottom])
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 8, style: .continuous))

                NavigationLink(value: task.project) {
                    Label("Go to Project", systemImage: "folder")
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .navigationTitle(task.project.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil.line") {
                    taskToEdit = task
                }
            }
        }
        .sheet(item: $taskToEdit) { task in
            TaskFormView(project: task.project, task: task) {
                dismiss()
            }
        }
    }

    private var overdueDays: Int? {
        let calendar = Calendar.autoupdatingCurrent
        let dueDay = calendar.startOfDay(for: task.dueDate)
        let today = calendar.startOfDay(for: .now)
        guard dueDay < today else { return nil }
        let days = calendar.dateComponents([.day], from: dueDay, to: today).day ?? 0
        return max(days, 1)
    }
}

#Preview {
    let project = SampleData.makeProjects()[0]
    let task = project.tasks?.first ?? ProjectTask(
        title: "Test title",
        details: "Test details",
        status: .default,
        dueDate: .now.addingTimeInterval(14 * 24 * 60 * 60),
        priority: .default,
        creationDate: .now,
        project: project
    )

    NavigationStack {
        TaskDetailView(task: task)
    }
    .modelContainer(SampleData.makePreviewContainer())
}
