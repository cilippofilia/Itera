//
//  ProjectRelease+DisplayText.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import Foundation

extension ProjectRelease {
    var displayText: String? {
        if version.isEmpty, build.isEmpty { return nil }
        if version.isEmpty { return "Build \(build)" }
        if build.isEmpty { return "v\(version)" }
        return "v\(version) (\(build))"
    }
}

extension Project {
    var releaseDisplayText: String? {
        currentRelease?.displayText
    }
}
