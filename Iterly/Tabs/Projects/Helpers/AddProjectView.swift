//
//  AddProjectView.swift
//  Iterly
//
//  Created by Filippo Cilia on 07/03/2026.
//

import SwiftData
import SwiftUI

struct AddProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = ProjectViewModel()
    @State private var title = ""
    @State private var details = ""
    @State private var version = ""
    @State private var build = ""
    @State private var priority: ProjectPriority = .default
    @State private var status: ProjectStatus = .default
    @State private var color: ProjectColor = .accentColor
    @State private var isPinned = false
    @State private var isEditing = false

    private let project: Project?

    init(project: Project? = nil) {
        self.project = project
        _isEditing = State(initialValue: project != nil)
        _title = State(initialValue: project?.title ?? "")
        _details = State(initialValue: project?.details ?? "")
        _version = State(initialValue: project?.currentRelease?.version ?? "")
        _build = State(initialValue: project?.currentRelease?.build ?? "")
        _priority = State(initialValue: project?.priority ?? .default)
        _status = State(initialValue: project?.status ?? .default)
        _color = State(initialValue: project?.highlight ?? .accentColor)
        _isPinned = State(initialValue: project?.isPinned ?? false)
    }

    private var canSave: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Project Title", text: $title)
                    TextField("Project Details", text: $details, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Settings") {
                    TextField("Release version", text: $version)
                    TextField("Build number", text: $build)
                    Picker("Status", selection: $status) {
                        ForEach(ProjectStatus.allCases, id: \.self) { status in
                            Text(status.title)
                                .tag(status)
                        }
                    }
                    .pickerStyle(.navigationLink)

                    Picker("Priority", selection: $priority) {
                        ForEach(ProjectPriority.allCases, id: \.self) { priority in
                            Text(priority.title)
                                .tag(priority)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }

                Section("Color") {
                    ProjectColorPickerGrid(selection: $color)
                }

                if isEditing {
                    Section {
                        Button(action: {
                            closeProject()
                        }) {
                            Label("Close Project", systemImage: "trash")
                        }
                        .buttonStyle(.plain)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 8, style: .continuous))

                        Button(role: .destructive, action: {
                            deleteProject()
                        }) {
                            Label("Delete Project", systemImage: "trash")
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.2))
                        .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    }
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProject()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func saveProject() {
        if let project {
            updateProject(project)
            dismiss()
            return
        }

        viewModel.createProject(
            title: title,
            details: details,
            priority: priority,
            status: status,
            color: color,
            isPinned: isPinned,
            version: version,
            build: build,
            modelContext: modelContext
        )
        dismiss()
    }

    private func updateProject(_ project: Project) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)

        project.title = trimmedTitle
        project.details = trimmedDetails.isEmpty ? nil : trimmedDetails
        project.priority = priority
        project.status = status
        project.highlight = color
        project.isPinned = isPinned
        project.touch()

        if let release = project.currentRelease {
            release.version = version
            release.build = build
        } else {
            let release = ProjectRelease(version: version, build: build, project: project)
            project.currentRelease = release
            modelContext.insert(release)
        }

        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to update project: \(error)")
        }
    }

    private func closeProject() {
        guard let project else { return }
        status = .closed
        isPinned = false
        updateProject(project)
        dismiss()
    }

    private func deleteProject() {
        guard let project else { return }
        viewModel.deleteProject(project, modelContext: modelContext)
        dismiss()
    }
}

#Preview {
    AddProjectView()
        .modelContainer(SampleData.makePreviewContainer())
}
