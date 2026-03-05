//
//  ProjectDetailView.swift
//  Iterly
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftData
import SwiftUI

struct ProjectDetailView: View {
    let project: Project

    var body: some View {
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

                GroupBox("Info") {
                    LabeledContent("Status") {
                        Menu {
                            Picker("Status", selection: Binding(
                                get: { project.status },
                                set: { project.status = $0 }
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
                    LabeledContent("Priority") {
                        Menu {
                            Picker("Priority", selection: Binding(
                                get: { project.priority },
                                set: { project.priority = $0 }
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
                    LabeledContent("Current Release", value: releaseText(for: project))
                }
                .padding(.bottom)

                if let tasks = project.tasks, !tasks.isEmpty {
                    Text("Tasks")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    ForEach(tasks) { task in
                        TaskRowView(task: task)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationDestination(for: UUID.self) { taskId in
            if let task = project.tasks?.first(where: { $0.id == taskId }) {
                TaskDetailView(task: task)
            }
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
}

#Preview("Light") {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
    }
    .modelContainer(SampleData.previewContainer)
}
#Preview("Dark") {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
            .preferredColorScheme(.dark)
    }
    .modelContainer(SampleData.previewContainer)
}
