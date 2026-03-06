//
//  Priority-Enums.swift
//  Iterly
//
//  Created by Filippo Cilia on 01/03/2026.
//

import SwiftUI

enum ProjectPriority: String, CaseIterable, Codable {
    static let `default` = Self.notSet

    case notSet
    case low
    case medium
    case high

    var title: String {
        switch self {
        case .notSet:
            "Not Set"
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .notSet:
            return .secondary.opacity(0.5)
        case .low:
            return .blue
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    static let `default` = Self.notSet

    case notSet
    case low
    case medium
    case high

    var title: String {
        switch self {
        case .notSet:
            "Not Set"
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        }
    }
    var badgeTitle: String {
        switch self {
        case .notSet:
            return "P3"
        case .low:
            return "P2"
        case .medium:
            return "P1"
        case .high:
            return "P0"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .notSet:
            return .secondary.opacity(0.5)
        case .low:
            return .blue
        case .medium:
            return .yellow
        case .high:
            return .orange
        }
    }
    var badgeBackgroundColor: Color {
        switch self {
        case .notSet:
            return .blue
        case .low:
            return .yellow
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}
