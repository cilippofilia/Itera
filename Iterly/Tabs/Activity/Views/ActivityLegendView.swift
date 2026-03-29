//
//  ActivityLegendView.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import SwiftUI

struct ActivityLegendView: View {
    var body: some View {
        HStack(spacing: 6) {
            Text("Less")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(0 ..< 5, id: \.self) { level in
                Rectangle()
                    .fill(color(for: level))
                    .frame(width: 14, height: 14)
                    .clipShape(.rect(cornerRadius: 4))
            }

            Text("More")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Activity legend from less to more")
    }

    private func color(for level: Int) -> Color {
        switch level {
        case 0: Color.secondary.opacity(0.12)
        case 1: Color.green.opacity(0.24)
        case 2: Color.green.opacity(0.45)
        case 3: Color.green.opacity(0.7)
        default: Color.green
        }
    }
}
