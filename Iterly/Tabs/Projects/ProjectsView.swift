//
//  ProjectsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 25/02/2026.
//

import SwiftData
import SwiftUI

struct ProjectsView: View {
    static let projectsTag: String? = "Projects"

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProjectViewModel()

    @Query(sort: \Project.creationDate, order: .reverse)
    private var projects: [Project]

    var body: some View {
        NavigationStack {
            Group {
                if projects.isEmpty {
                    UnavailableProjectsView()
                } else {
                    List(projects) { project in
                        NavigationLink(value: project) {
                            ProjectCell(
                                title: project.title,
                                tasksCount: project.tasks?.count ?? 0,
                                progressValue: project.completionAmount,
                                progressColor: project.highlight.color
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Projects")
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    createProjectButton
                }
            }
        }
    }

    var createProjectButton: some View {
        Button(
            "Add Project",
            systemImage: "plus",
            action: {
                viewModel.createProject(modelContext: modelContext)
            }
        )
    }
}

#Preview {
    ProjectsView()
        .modelContainer(SampleData.previewContainer)
}
