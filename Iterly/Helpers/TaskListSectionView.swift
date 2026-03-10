//
//  TaskListSectionView.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import SwiftUI

struct TaskListSectionView: View {
    let title: String
    let tasks: [ProjectTask]

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.secondary)
            .padding(.top)

        ForEach(tasks) { task in
            TaskRowView(task: task)
        }
    }
}
