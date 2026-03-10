//
//  TaskSectionsBuilder.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import Foundation

struct TaskSectionsBuilder {
    struct Sections {
        let active: [ProjectTask]
        let completed: [ProjectTask]
        let closed: [ProjectTask]
    }

    static func sections(for tasks: [ProjectTask]) -> Sections {
        Sections(
            active: tasks.filter { $0.status != .done && $0.status != .closed },
            completed: tasks.filter { $0.status == .done },
            closed: tasks.filter { $0.status == .closed }
        )
    }
}
