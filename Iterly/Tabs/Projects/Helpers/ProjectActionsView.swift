//
//  ProjectActionsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import SwiftUI

struct ProjectActionsView: View {
    @Binding var showBrainstormSheet: Bool

    var body: some View {
        PrimaryCapsuleActionButton(
            title: "Brainstorm",
            systemImage: "brain",
            action: {
                showBrainstormSheet = true
            }
        )
    }
}
