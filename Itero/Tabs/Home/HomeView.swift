//
//  HomeView.swift
//  Itero
//
//  Created by Filippo Cilia on 25/02/2026.
//

import CoreSpotlight
import SwiftUI

struct HomeView: View {
    static let homeTag: String? = "Home"

    private let projectRows = [
        GridItem(.fixed(100))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // pinned section
                    HStack {
                        Image(systemName: "pin.fill")
                            .imageScale(.small)
                            .rotationEffect(Angle(degrees: 45))
                        Text("Pinned")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(0...2, id: \.self) { i in
                            NavigationLink(value: HomeDestination.project(i)) {
                                ProjectCell(title: "Drinko", tasksCount: i)
                                    .background(Color.green.opacity(0.3))
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    // projects
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: projectRows) {
                            // add limit of 5 then 6th will be a `see more` that opens projects tabs
                            ForEach(0...5, id: \.self) { i in
                                NavigationLink(value: HomeDestination.project(i)) {
                                    ProjectCell(title: "Drinko", tasksCount: i)
                                        .background(Color.yellow.opacity(0.3))
                                        .clipShape(.rect(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)

                    // tasks
                    VStack(alignment: .leading) {
                        Text("Up next:")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        ForEach(0...5, id: \.self) { i in
                            NavigationLink(value: HomeDestination.task(i)) {
                                TaskCell(title: "Task \(i)")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                Button(
                    "Add Data",
                    systemImage: "plus",
                    action: {
                        print("Adding data...")
                    }
                )
            }
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .project(let id):
                    ProjectPlaceholderView(projectID: id)
                case .task(let id):
                    TaskPlaceholderView(taskID: id)
                }
            }
            .contentMargins(.bottom, 70, for: .scrollContent)
        }
    }
}

#Preview {
    HomeView()
}
