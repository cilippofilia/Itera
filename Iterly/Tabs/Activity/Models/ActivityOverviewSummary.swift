//
//  ActivityOverviewSummary.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import Foundation

struct ActivityOverviewSummary {
    let totalCount: Int
    let streak: Int
    let busiestDay: ActivityDaySummary?

    static let empty = ActivityOverviewSummary(totalCount: 0, streak: 0, busiestDay: nil)
}
