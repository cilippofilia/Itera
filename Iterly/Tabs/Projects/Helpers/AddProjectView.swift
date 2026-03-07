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
    @State private var priority: ProjectPriority = .default
    @State private var status: ProjectStatus = .default
    @State private var color: ProjectColor = .accentColor
    @State private var isPinned = false

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
        viewModel.createProject(
            title: title,
            details: details,
            priority: priority,
            status: status,
            color: color,
            isPinned: isPinned,
            modelContext: modelContext
        )
        dismiss()
    }
}

#Preview {
    AddProjectView()
        .modelContainer(SampleData.makePreviewContainer())
}
