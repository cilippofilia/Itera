import Foundation
import SwiftData

@MainActor
@Observable
final class ProjectViewModel {
    private let maxPinnedProjects = 4

    func createProject(modelContext: ModelContext) {
        let project = Project(title: "New Project")
        modelContext.insert(project)

        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to create project: \(error)")
        }
    }

    func createProject(
        title: String,
        details: String,
        priority: ProjectPriority,
        status: ProjectStatus,
        color: ProjectColor,
        isPinned: Bool,
        version: String,
        build: String,
        modelContext: ModelContext
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)

        let project = Project(
            title: trimmedTitle,
            details: trimmedDetails.isEmpty ? nil : trimmedDetails,
            projectPriority: priority,
            projectStatus: status,
            color: color,
            creationDate: .now,
            lastUpdated: .now,
            isPinned: false
        )

        let release = ProjectRelease(version: version, build: build, project: project)
        project.currentRelease = release

        modelContext.insert(project)

        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to create project: \(error)")
        }
    }

    func addSampleData(modelContext: ModelContext) {
        SampleData.insertSample(in: modelContext)
    }

    func togglePin(project: Project, modelContext: ModelContext) -> Bool {
        do {
            if project.isPinned == false {
                let descriptor = FetchDescriptor<Project>(
                    predicate: #Predicate<Project> { $0.isPinned == true }
                )
                let pinnedCount = try modelContext.fetchCount(descriptor)
                if pinnedCount >= maxPinnedProjects {
                    return false
                }
            }

            project.isPinned.toggle()
            project.touch()

            try modelContext.save()
            return true
        } catch {
            assertionFailure("Failed to toggle pin: \(error)")
            return false
        }
    }

    func deleteProject(_ project: Project, modelContext: ModelContext) {
        if let release = project.currentRelease {
            modelContext.delete(release)
        }
        modelContext.delete(project)

        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to delete project: \(error)")
        }
    }

    func eraseAllData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: ProjectTask.self)
            try modelContext.delete(model: ProjectRelease.self)
            try modelContext.delete(model: Project.self)

            try modelContext.save()
        } catch {
            assertionFailure("Failed to erase data: \(error)")
        }
    }
}
