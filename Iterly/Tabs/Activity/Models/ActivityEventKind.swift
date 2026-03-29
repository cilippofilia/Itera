//
//  ActivityEventKind.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import Foundation

enum ActivityEventKind: String, Hashable {
    case project
    case task

    var title: String {
        switch self {
        case .project: "Project"
        case .task: "Task"
        }
    }
}
