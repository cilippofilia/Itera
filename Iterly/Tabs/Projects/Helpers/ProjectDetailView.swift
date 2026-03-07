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
    @Bindable var project: Project

    var body: some View {
        let tasks = project.tasks ?? []
        let activeTasks = tasks.filter { $0.status != .done }
        let completedTasks = tasks.filter { $0.status == .done }

        ScrollView {
            VStack(alignment: .leading) {
                Text(project.title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primary)

                if let details = project.details, !details.isEmpty {
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
                                get: { project.status },
                                set: {
                                    project.status = $0
                                    project.touch()
                                }
                            )) {
                                ForEach(ProjectStatus.allCases, id: \.self) { status in
                                    Text(status.title)
                                        .tag(status)
                                }
                            }
                        } label: {
                            Text(project.status.title)
                                .badgeStyle(backgroundColor: project.status.backgroundColor)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)

                    LabeledContent("Priority") {
                        Menu {
                            Picker("Priority", selection: Binding(
                                get: { project.priority },
                                set: {
                                    project.priority = $0
                                    project.touch()
                                }
                            )) {
                                ForEach(ProjectPriority.allCases, id: \.self) { priority in
                                    Text(priority.title)
                                        .tag(priority)
                                }
                            }
                        } label: {
                            Text(project.priority.title)
                                .badgeStyle(backgroundColor: project.priority.backgroundColor)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)

                    LabeledContent("Current Release", value: releaseText(for: project))
                        .padding([.horizontal, .bottom])
                }
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 8, style: .continuous))
                .padding(.bottom)

                if !activeTasks.isEmpty {
                    Text("Tasks")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    ForEach(activeTasks) { task in
                        TaskRowView(task: task)
                    }

                    Button(action: {
                        addTask()
                    }) {
                        Label("Add task", systemImage: "plus")
                    }
                    .padding(4)
                }

                if !completedTasks.isEmpty {
                    Text("Completed Tasks")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.top)

                    ForEach(completedTasks) { task in
                        TaskRowView(task: task)
                    }
                }

                pinButtonView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .contentMargins(.bottom, 70, for: .scrollContent)
        .navigationDestination(for: UUID.self) { taskId in
            if let task = project.tasks?.first(where: { $0.id == taskId }) {
                TaskDetailView(task: task)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil.line") {
                    projectToEdit = project
                }
            }
        }
        .sheet(item: $projectToEdit) { project in
            ProjectFormView(project: project)
        }
        .alert("Can't Pin Project", isPresented: $showPinLimitAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Only 4 projects can be pinned at the same time.")
        }
    }

    private func releaseText(for project: Project) -> String {
        guard let release = project.currentRelease else {
            return "Not Set"
        }

        if release.version.isEmpty, release.build.isEmpty {
            return "Not Set"
        }

        if release.version.isEmpty {
            return "Build \(release.build)"
        }

        if release.build.isEmpty {
            return "v\(release.version)"
        }

        return "v\(release.version) (\(release.build))"
    }

    private func addTask() {
        withAnimation(.snappy) {
            let newTask = ProjectTask(project: project)
            modelContext.insert(newTask)

            if project.tasks == nil {
                project.tasks = []
            }
            project.tasks?.append(newTask)
            project.touch()
        }
    }

    private var pinButtonView: some View {
        Button(action: {
            if viewModel.togglePin(project: project, modelContext: modelContext) == false {
                showPinLimitAlert = true
            }
        }) {
            HStack {
                Image(systemName: "pin")
                    .rotationEffect(Angle(degrees: 45))
                    .symbolVariant(project.isPinned ? .fill : .none)

                Text(project.isPinned ? "Unpin from" : "Pin to") +
                Text(" dashboard")
            }
        }
        .buttonStyle(.plain)
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 8, style: .continuous))
        .padding(.top)
    }
}

#Preview("Light") {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
    }
    .modelContainer(SampleData.makePreviewContainer())
}
#Preview("Dark") {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
            .preferredColorScheme(.dark)
    }
    .modelContainer(SampleData.makePreviewContainer())
}
