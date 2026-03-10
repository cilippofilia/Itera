//
//  ProjectDetailView.swift
//  Iterly
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftData
import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProjectViewModel()
    @State private var showPinLimitAlert: Bool = false
    @State private var projectToEdit: Project?
    @State private var showAddTaskSheet: Bool = false
    @State private var showBrainstormSheet: Bool = false

    @Bindable var project: Project

    var body: some View {
        let sections = TaskSectionsBuilder.sections(for: project.topLevelTasks)

        ScrollView {
            VStack(alignment: .leading) {
                if let details = project.details, !details.isEmpty {
                    Text(details)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }

                ProjectInfoBoxView(project: project)

                ProjectActionsView(showBrainstormSheet: $showBrainstormSheet)

                ProjectTaskSectionsView(
                    sections: sections,
                    onAddTask: {
                        showAddTaskSheet = true
                    }
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .navigationTitle(project.title)
        .contentMargins(.bottom, 70, for: .scrollContent)
        .navigationDestination(for: UUID.self) { taskId in
            if let task = project.tasks?.first(where: { $0.id == taskId }) {
                TaskDetailView(task: task)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if viewModel.togglePin(project: project, modelContext: modelContext) == false {
                        showPinLimitAlert = true
                    }
                }) {
                    Image(systemName: "pin")
                        .rotationEffect(Angle(degrees: 45))
                        .symbolVariant(project.isPinned ? .fill : .none)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil.line") {
                    projectToEdit = project
                }
            }
        }
        .sheet(item: $projectToEdit) { project in
            NavigationStack {
                ProjectFormView(project: project)
            }
        }
        .sheet(isPresented: $showAddTaskSheet) {
            NavigationStack {
                TaskFormView(project: project)
            }
        }
        .sheet(isPresented: $showBrainstormSheet) {
            NavigationStack {
                BrainstormFormView(text: Binding(
                    get: { project.note ?? "" },
                    set: { project.note = $0.isEmpty ? nil : $0 }
                ))
            }
            .presentationDetents([.medium])
        }
        .alert("Can't Pin Project", isPresented: $showPinLimitAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Only 4 projects can be pinned at the same time.")
        }
    }
}

#Preview("Light") {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
    }
    .modelContainer(SampleData.makePreviewContainer())
}
