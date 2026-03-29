//
//  ActivityDayDetailSectionView.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import SwiftUI

struct ActivityDayDetailSectionView: View {
    let selectedDay: ActivityDaySummary?
    let events: [ActivityEvent]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Selected Day")
                .font(.headline)

            if let selectedDay {
                Text(selectedDay.date, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("\(selectedDay.count) total")
                    Text("•")
                    Text("\(selectedDay.projectCount) project")
                    Text("•")
                    Text("\(selectedDay.taskCount) task")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if events.isEmpty {
                    Text("No activity for this day.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(events.prefix(4))) { event in
                        HStack(alignment: .top) {
                            Text(event.kind.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 48, alignment: .leading)

                            VStack(alignment: .leading) {
                                Text(event.title)
                                Text(event.context)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    if events.count > 4 {
                        Text("+\(events.count - 4) more")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("Select a day to inspect activity.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }
}
