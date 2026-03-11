//
//  SecondaryCapsuleActionButton.swift
//  Iterly
//
//  Created by Filippo Cilia on 10/03/2026.
//

import SwiftUI

struct SecondaryCapsuleActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .secondaryCapsuleButtonStyle()
        }
    }
}
