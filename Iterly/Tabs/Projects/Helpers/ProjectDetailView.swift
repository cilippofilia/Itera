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
    @Environment(\.openURL) private var openURL
    @State private var viewModel = ProjectViewModel()
    @State private var showPinLimitAlert: Bool = false
    @State private var projectToEdit: Project?
    @State private var showAddTaskSheet: Bool = false
    @State private var showBrainstormSheet: Bool = false
    @State private var isRefreshingAppStore = false
    @State private var appStoreSyncErrorMessage: String?

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

                ProjectInfoBoxView(
                    project: project,
                    isSyncingAppStore: isRefreshingAppStore
                )

                HStack {
                    PrimaryCapsuleActionButton(
                        title: "Brainstorm",
                        systemImage: "brain",
                        action: { showBrainstormSheet = true }
                    )

                    if let appStoreURL = project.currentRelease?.appStoreURL.trimmingCharacters(in: .whitespacesAndNewlines),
                       appStoreURL.isEmpty == false,
                       let destination = URL(string: appStoreURL) {
                        SecondaryCapsuleActionButton(
                            title: "Go to AppStore",
                            systemImage: "arrow.up.right.square",
                            action: { openURL(destination) }
                        )
                    }
                }

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
        .alert("App Store Sync Failed", isPresented: Binding(
            get: { appStoreSyncErrorMessage != nil },
            set: { newValue in
                if newValue == false {
                    appStoreSyncErrorMessage = nil
                }
            }
        )) {
            Button("OK", role: .cancel) {
                appStoreSyncErrorMessage = nil
            }
        } message: {
            Text(appStoreSyncErrorMessage ?? "Something went wrong.")
        }
    }

    private func refreshAppStoreRelease() async {
        isRefreshingAppStore = true
        defer { isRefreshingAppStore = false }

        do {
            try await viewModel.refreshAppStoreRelease(for: project, modelContext: modelContext)
            appStoreSyncErrorMessage = nil
        } catch {
            viewModel.saveAppStoreSyncError(error, for: project, modelContext: modelContext)
            appStoreSyncErrorMessage = error.localizedDescription
        }
    }

    private func disconnectAppStoreRelease() {
        do {
            try viewModel.disconnectAppStoreRelease(for: project, modelContext: modelContext)
            appStoreSyncErrorMessage = nil
        } catch {
            appStoreSyncErrorMessage = error.localizedDescription
        }
    }
}

#Preview("Light") {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
    }
    .modelContainer(SampleData.makePreviewContainer())
}
