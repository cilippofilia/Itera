//
//  ActivityDaySummary.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import Foundation

struct ActivityDaySummary: Identifiable, Hashable {
    let date: Date
    let count: Int
    let projectCount: Int
    let taskCount: Int
    let intensityLevel: Int

    var id: Date {
        date
    }

    var isEmpty: Bool {
        count == 0
    }
}
