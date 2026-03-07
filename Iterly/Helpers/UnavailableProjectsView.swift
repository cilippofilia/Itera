//
//  UnavailableProjectsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 05/03/2026.
//

import SwiftData
import SwiftUI

struct UnavailableProjectsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProjectViewModel()

    var body: some View {
        ContentUnavailableView {
            Label("No projects found", systemImage: "folder.badge.questionmark")
        } description: {
            Text("There are no active projects at the moment. Create one to get started.")
        } actions: {
            addSampleDataButton
            createProjectButton
        }
    }

    private var createProjectButton: some View {
        Button(
            "Add Project",
            systemImage: "plus",
            action: createProject
        )
    }

    private var addSampleDataButton: some View {
        Button(
            "Add Data",
            systemImage: "sparkles",
            action: addSampleData
        )
    }

    private func createProject() {
        viewModel.createProject(modelContext: modelContext)
    }

    private func addSampleData() {
        viewModel.addSampleData(modelContext: modelContext)
    }
}

#Preview {
    UnavailableProjectsView()
        .modelContainer(SampleData.makePreviewContainer())
}
