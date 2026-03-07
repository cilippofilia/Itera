//
//  ProjectColorPickerGrid.swift
//  Iterly
//
//  Created by Filippo Cilia on 07/03/2026.
//

import SwiftUI

struct ProjectColorPickerGrid: View {
    @Binding var selection: ProjectColor

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(ProjectColor.allCases, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(option.color)
                        .overlay {
                            if selection == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(option.title))
                .accessibilityValue(selection == option ? "Selected" : "Not selected")
            }
        }
    }
}

#Preview {
    ProjectColorPickerGrid(selection: .constant(.red))
        .padding()
}
