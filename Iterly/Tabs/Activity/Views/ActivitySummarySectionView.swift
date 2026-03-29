//
//  ActivitySummarySectionView.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import SwiftUI

struct ActivitySummarySectionView: View {
    let summary: ActivityOverviewSummary

    var body: some View {
        HStack {
            metric(title: "Streak", value: "\(summary.streak)", detail: summary.streak == 1 ? "active day" : "active days")
            Spacer()
            metric(title: "Total", value: "\(summary.totalCount)", detail: "activities")
            Spacer()
            metric(
                title: "Busiest",
                value: busiestValue,
                detail: busiestDetail
            )
        }
        .padding()
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }

    private var busiestValue: String {
        guard let busiestDay = summary.busiestDay else { return "None" }
        return "\(busiestDay.count)"
    }

    private var busiestDetail: String {
        guard let busiestDay = summary.busiestDay else { return "no activity" }

        return busiestDay.date.formatted(.dateTime.month(.abbreviated).day())
    }

    private func metric(title: String, value: String, detail: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2)
                .bold()
                .monospacedDigit()

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
