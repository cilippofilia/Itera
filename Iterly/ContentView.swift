//
//  ContentView.swift
//  Iterly
//
//  Created by Filippo Cilia on 25/02/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @AppStorage("selectedView") var selectedView: String?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView(selection: $selectedView) {
            Tab("Home", systemImage: "house", value: HomeView.homeTag) {
                HomeView()
            }

            Tab("Projects", systemImage: "folder", value: ProjectsView.projectsTag) {
                ProjectsView()
            }
        }
        .task {
            backfillProjectTypesIfNeeded()
        }
    }

    private func backfillProjectTypesIfNeeded() {
        let descriptor = FetchDescriptor<Project>()

        do {
            let projects = try modelContext.fetch(descriptor)
            let projectsNeedingBackfill = projects.filter(\.needsTypeBackfill)

            guard projectsNeedingBackfill.isEmpty == false else { return }

            for project in projectsNeedingBackfill {
                project.backfillTypeIfNeeded()
            }

            try modelContext.save()
        } catch {
            assertionFailure("Failed to backfill project types: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.makePreviewContainer())
}
