//
//  HomeViewModel.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    func upcomingTasks(from tasks: [ProjectTask]) -> [ProjectTask] {
        tasks
            .filter { $0.project.status != .closed }
            .filter { $0.status != .done }
            .filter { $0.parentTask == nil }
            .sorted { lhs, rhs in
                if lhs.dueDate != rhs.dueDate {
                    return lhs.dueDate < rhs.dueDate
                }
                return lhs.priority.sortRank < rhs.priority.sortRank
            }
    }

    func totalProjectsCount(pinned: [Project], projects: [Project]) -> Int {
        pinned.count + projects.count
    }
}
