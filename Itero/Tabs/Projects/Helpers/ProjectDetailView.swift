//
//  ProjectDetailView.swift
//  Itero
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftUI

struct ProjectDetailView: View {
    @State private var isEditing: Bool = false
    @State private var markTaskAsCompleted: Bool = false

    let project: Project

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let title = project.title {
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.primary)
                }
                if let details = project.details, !details.isEmpty {
                    Text(details)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }

                GroupBox("Info") {
                    LabeledContent("Status", value: project.status?.title ?? "Unknown")
                    LabeledContent("Priority", value: project.priority?.title ?? "Normal")

                    if let startDate = project.startDate {
                        LabeledContent("Start Date") {
                            Text(startDate, format: .dateTime.month().day().year())
                        }
                    }

                    if let dueDate = project.dueDate {
                        LabeledContent("Due Date") {
                            Text(dueDate, format: .dateTime.month().day().year())
                        }
                    }
                }
                .padding(.bottom)

                // TODO: make these tappable like todo's in notes
                if let tasks = project.tasks, !tasks.isEmpty {
                    Text("Tasks")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    ForEach(tasks) { task in
                        Button(action: toggleTaskCompletion) {
                            HStack {
                                Image(systemName: markTaskAsCompleted ? "checkmark.circle" : "circle")
                                    .foregroundStyle(markTaskAsCompleted ? .green : .secondary)
                                    .symbolEffect(.bounce, value: markTaskAsCompleted)
                                Text(task.title)
                                    .foregroundStyle(markTaskAsCompleted ? .secondary : .primary)
                                    .strikethrough(markTaskAsCompleted, color: .secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(4)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "square.and.pencil") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditProjectDetails(project: project)
        }
    }

    private func toggleTaskCompletion() {
        withAnimation(.snappy) {
            markTaskAsCompleted.toggle()
        }
    }
}

#Preview {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
    }
}
