//
//  SettingsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 3/30/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    static let settingsTag: String? = "Settings"

    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL

    @AppStorage("settings.showCompletedTasks") private var showCompletedTasks: Bool = true
    @AppStorage("settings.highlightOverdueTasks") private var highlightOverdueTasks: Bool = true
    @AppStorage("settings.compactProjectCards") private var compactProjectCards: Bool = false

    @State private var projectViewModel = ProjectViewModel()
    @State private var showContactOptions: Bool = false
    @State private var showAddSampleDataAlert: Bool = false
    @State private var showEraseAllDataAlert: Bool = false

    private let supportEmail = "cilia.filippo.dev@gmail.com"
    private let appShareURLString = "https://apps.apple.com/app/id0000000000"
    private let appName = "Iterly"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Show completed tasks", isOn: $showCompletedTasks)
                    Toggle("Highlight overdue tasks", isOn: $highlightOverdueTasks)
                    Toggle("Compact project cards", isOn: $compactProjectCards)
                } header: {
                    Text("Preferences - not yet implemented")
                }

                Section {
                    NavigationLink {
                        ContentUnavailableView(
                            "No integrations yet",
                            systemImage: "link",
                            description: Text("Connected services and sync options can be added here later.")
                        )
                    } label: {
                        FormRowView(
                            imageName: "link",
                            foregroundColor: .white,
                            backgroundColor: .blue,
                            text: "Integrations"
                        )
                    }

                    NavigationLink {
                        ContentUnavailableView(
                            "No exports yet",
                            systemImage: "square.and.arrow.up",
                            description: Text("Export and backup options can be added here later.")
                        )
                    } label: {
                        FormRowView(
                            imageName: "square.and.arrow.down",
                            foregroundColor: .white,
                            backgroundColor: .secondary,
                            text: "Export Data"
                        )
                    }
                } header: {
                    Text("Data - not yet implemented")
                }

                Section("Data Management") {
                    Button {
                        SampleData.insertSample(in: modelContext)
                        showAddSampleDataAlert = true
                    } label: {
                        FormRowView(
                            imageName: "wand.and.sparkles",
                            foregroundColor: .white,
                            backgroundColor: .indigo.mix(with: .purple, by: 0.5),
                            text: "Add Sample Data"
                        )
                    }
                    .buttonStyle(.plain)

                    Button(role: .destructive) {
                        showEraseAllDataAlert = true
                    } label: {
                        FormRowView(
                            imageName: "trash",
                            foregroundColor: .white,
                            backgroundColor: .red,
                            text: "Erase All Data"
                        )
                    }
                    .buttonStyle(.plain)
                }

                Section {
                    Button {
                        showContactOptions = true
                    } label: {
                        FormRowView(
                            imageName: "envelope",
                            foregroundColor: .white,
                            backgroundColor: .blue.mix(with: .white, by: 0.1),
                            text: "Contact the developer"
                        )
                    }
                    .buttonStyle(.plain)
                    .tint(.red)
                    .confirmationDialog(
                        "Select an option",
                        isPresented: $showContactOptions,
                        titleVisibility: .visible
                    ) {
                        Button("Report a bug") {
                            openMail(
                                subject: "Bug Report",
                                body: "Please provide as many details about the bug you encountered as possible - and include screenshots if possible."
                            )
                        }

                        Button("Request a Feature") {
                            openMail(
                                subject: "Feature idea",
                                body: ""
                            )
                        }

                        Button("Other Enquiry") {
                            openMail(
                                subject: "",
                                body: ""
                            )
                        }
                    }

                    Button {
                        if let appStoreReviewURL {
                            openURL(appStoreReviewURL)
                        }
                    } label: {
                        FormRowView(
                            imageName: "star.fill",
                            foregroundColor: .yellow,
                            backgroundColor: .secondary,
                            text: "Rate the app"
                        )
                    }
                    .buttonStyle(.plain)

                    if let appShareURL {
                        ShareLink(item: appShareURL) {
                            FormRowView(
                                imageName: "square.and.arrow.up",
                                foregroundColor: .white,
                                backgroundColor: .secondary,
                                text: "Share the app"
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        ShareLink(item: "Check out \(appName)") {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.secondary)
                                Text("Share the app")
                            }
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Contacts")
                } footer: {
                    Text("App Version: \(currentVersion)")
                        .font(.footnote)
                }
            }
            .navigationTitle("Settings")
            .alert("Sample Data Added", isPresented: $showAddSampleDataAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Sample projects and tasks have been added to the app.")
            }
            .alert("Erase All Data?", isPresented: $showEraseAllDataAlert) {
                Button("Erase", role: .destructive) {
                    projectViewModel.eraseAllData(modelContext: modelContext)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently remove all projects, tasks, and releases.")
            }
        }
    }

    private var currentVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(version) (\(build))"
    }

    private var appShareURL: URL? {
        URL(string: appShareURLString)
    }

    private var appStoreReviewURL: URL? {
        guard let appShareURL else { return nil }
        return URL(string: "\(appShareURL.absoluteString)?action=write-review")
    }

    private func openMail(subject: String, body: String) {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]

        guard let mailURL = components.url else { return }
        openURL(mailURL)
    }
}

#Preview {
    SettingsView()
}
