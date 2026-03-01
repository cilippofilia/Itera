//
//  ProjectCell.swift
//  Itero
//
//  Created by Filippo Cilia on 01/03/2026.
//

import SwiftUI

struct ProjectCell: View {
    let title: String
    let tasksCount: Int

    var body: some View {
        HStack {
            Image(systemName: "circle")
                .imageScale(.large)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .lineLimit(1)
                Text(String.localizedStringWithFormat(NSLocalizedString("tasks_count", comment: "Tasks count"), tasksCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 70)
    }
}

#Preview {
    ProjectCell(title: "Drinko", tasksCount: 4)
}
