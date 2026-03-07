//
//  EditProjectDetails.swift
//  Iterly
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftData
import SwiftUI

struct EditProjectDetails: View {
    let project: Project

    var body: some View {
        EmptyView()
    }
}

#Preview {
    EditProjectDetails(project: SampleData.makeProjects()[0])
        .modelContainer(SampleData.makePreviewContainer())
}
