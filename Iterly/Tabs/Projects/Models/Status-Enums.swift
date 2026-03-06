//
//  Status-Enums.swift
//  Iterly
//
//  Created by Filippo Cilia on 01/03/2026.
//

import Foundation
import SwiftUI

enum ProjectStatus: String, CaseIterable, Codable {
    static let `default` = Self.plan

    case plan
    case dev
    case beta
    case live
    case blocked

    var title: String {
        switch self {
        case .plan:
            return "Planning"
        case .dev:
            return "Development"
        case .beta:
            return "Beta"
        case .live:
            return "Live"
        case .blocked:
            return "Blocked"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .plan:
            return .secondary.opacity(0.5)
        case .dev:
            return .yellow
        case .beta:
            return .orange
        case .live:
            return .green
        case .blocked:
            return .red
        }
    }
}

enum TaskStatus: String, CaseIterable, Codable {
    static let `default` = Self.notStarted

    case blocked
    case notStarted
    case inProgress
    case done

    var title: String {
        switch self {
        case .blocked:
            return "Blocked"
        case .notStarted:
            return "Not Started"
        case .inProgress:
            return "In Progress"
        case .done:
            return "Done"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .blocked:
            return .red
        case .notStarted:
            return .secondary.opacity(0.5)
        case .inProgress:
            return .yellow
        case .done:
            return .green
        }
    }
}
