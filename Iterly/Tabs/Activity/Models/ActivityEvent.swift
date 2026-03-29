//
//  ActivityEvent.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import Foundation

struct ActivityEvent: Identifiable, Hashable {
    let date: Date
    let kind: ActivityEventKind
    let title: String
    let context: String

    var id: String {
        [
            String(date.timeIntervalSinceReferenceDate),
            kind.rawValue,
            title,
            context
        ].joined(separator: "|")
    }
}
