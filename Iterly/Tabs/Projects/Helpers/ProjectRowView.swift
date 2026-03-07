//
//  ProjectRowView.swift
//  Iterly
//
//  Created by Filippo Cilia on 06/03/2026.
//

import SwiftUI

struct ProjectRowView: View {
    let title: String
    let statusTitle: String
    let statusColor: Color
    
    let tasks: [ProjectTask]

    let blockedAmount: CGFloat
    let inProgressAmount: CGFloat
    let doneAmount: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                Text(statusTitle)
                    .badgeStyle(backgroundColor: statusColor)
            }

            Text(String.localizedStringWithFormat(NSLocalizedString("tasks_count", comment: "Tasks count"), tasks.count))
                .font(.caption)
                .foregroundStyle(.secondary)

            ProgressView(value: inProgressAmount + blockedAmount + doneAmount)
                .tint(tasks.first(where: { $0.status == .done })?.status.backgroundColor)
                .overlay {
                    ProgressView(value: inProgressAmount + blockedAmount)
                        .tint(tasks.first(where: { $0.status == .inProgress })?.status.backgroundColor)
                }
                .overlay {
                    ProgressView(value: blockedAmount)
                        .tint(tasks.first(where: { $0.status == .blocked })?.status.backgroundColor)
                }
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let data = SampleData.makeProjects()[0]
    ProjectRowView(title: data.title, statusTitle: data.status.title, statusColor: data.status.backgroundColor, tasks: data.tasks ?? [], blockedAmount: 0.1, inProgressAmount: 0.3, doneAmount: 0.4)
}
