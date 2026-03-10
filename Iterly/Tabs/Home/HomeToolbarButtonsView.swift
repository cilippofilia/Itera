//
//  HomeToolbarButtonsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import SwiftUI

struct HomeToolbarButtonsView: View {
    @Binding var showEraseDataAlert: Bool
    @Binding var showAddDataAlert: Bool

    var body: some View {
        Button(
            "Add Data",
            systemImage: "sparkles",
            action: {
                showAddDataAlert = true
            }
        )

        Button(
            "Erase Data",
            systemImage: "trash",
            role: .destructive,
            action: {
                showEraseDataAlert = true
            }
        )
    }
}
