//
//  ProjectsSection.swift
//  Itero
//
//  Created by Filippo Cilia on 25/02/2026.
//

import SwiftUI

struct ProjectsSection: View {
    let projects: [Project]?

    var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let projects, !projects.isEmpty {
                headerView

                LazyVGrid(columns: columns) {
                    ForEach(projects) { project in
                        NavigationLink(value: HomeDestination.project(id: project.id)) {
                            ProjectCell(
                                title: project.title,
                                tasksCount: project.tasks?.count ?? 0,
                                progressValue: project.completionAmount
                            )
                            .background(Color.yellow.opacity(0.3))
                            .clipShape(.rect(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    var headerView: some View {
        HStack {
            Image(systemName: "folder")
            Text("Projects")
                .font(.headline)
        }
        .padding(.horizontal)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    NavigationStack {
        ProjectsSection(projects: SampleData.makeProjects())
    }
}
