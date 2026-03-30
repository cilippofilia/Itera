//
//  IntegrationsSettingsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 3/31/26.
//

import SwiftData
import SwiftUI

struct IntegrationsSettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        sort: [
            SortDescriptor(\Project.lastUpdated, order: .reverse),
            SortDescriptor(\Project.creationDate, order: .reverse)
        ]
    )
    private var projects: [Project]

    @State private var projectViewModel = ProjectViewModel()
    @State private var activeErrorMessage: String?

    private var linkedProjects: [Project] {
        projects.filter { $0.currentRelease?.hasAppStoreLink == true }
    }

    var body: some View {
        Form {
            Section("App Store") {
                if linkedProjects.isEmpty {
                    ContentUnavailableView(
                        "No App Store Links",
                        systemImage: "link.badge.plus",
                        description: Text("Connect an App Store app from a project to manage it here.")
                    )
                } else {
                    ForEach(linkedProjects) { project in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(project.title)

                                if let release = project.currentRelease {
                                    Text("App ID \(release.extractedAppStoreAppID ?? "Unavailable")")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            Button("Remove", role: .destructive) {
                                disconnect(project)
                            }
                        }
                    }
                }
            }

            if linkedProjects.isEmpty == false {
                Section {
                    Button("Disconnect All App Store Links", role: .destructive) {
                        disconnectAll()
                    }
                } footer: {
                    Text("This removes App Store links from projects but keeps the projects, tasks, and release records.")
                }
            }
        }
        .navigationTitle("Integrations")
        .alert("Integration Error", isPresented: Binding(
            get: { activeErrorMessage != nil },
            set: { newValue in
                if newValue == false {
                    activeErrorMessage = nil
                }
            }
        )) {
            Button("OK", role: .cancel) {
                activeErrorMessage = nil
            }
        } message: {
            Text(activeErrorMessage ?? "Something went wrong.")
        }
    }

    private func disconnect(_ project: Project) {
        do {
            try projectViewModel.disconnectAppStoreRelease(for: project, modelContext: modelContext)
            activeErrorMessage = nil
        } catch {
            activeErrorMessage = error.localizedDescription
        }
    }

    private func disconnectAll() {
        do {
            try projectViewModel.disconnectAllAppStoreLinks(modelContext: modelContext)
            activeErrorMessage = nil
        } catch {
            activeErrorMessage = error.localizedDescription
        }
    }
}
