//
//  ProjectStatus.swift
//  Itero
//
//  Created by Filippo Cilia on 01/03/2026.
//

import Foundation

enum ProjectStatus: String, CaseIterable, Codable {
    static let `default` = Self.notSet

    case notSet
    case notStarted
    case inProgress
    case done

    var title: String {
        switch self {
        case .notSet:
            "Not Set"
        case .notStarted:
            "Not Started"
        case .inProgress:
            "In Progress"
        case .done:
            "Done"
        }
    }
}
