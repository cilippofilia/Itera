import Foundation
import SwiftData

@MainActor
@Observable
final class ProjectViewModel {
    func createProject(modelContext: ModelContext) {
        let project = Project(title: "New Project")
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

    func eraseAllData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: ProjectTask.self)
            try modelContext.delete(model: Project.self)

            try modelContext.save()
        } catch {
            assertionFailure("Failed to erase data: \(error)")
        }
    }
}
