//
//  SettingsView.swift
//  Iterly
//
//  Created by Filippo Cilia on 3/30/26.
//

import SwiftUI

struct SettingsView: View {
    static let settingsTag: String? = "Settings"

    @Environment(\.openURL) private var openURL

    @AppStorage("settings.showCompletedTasks") private var showCompletedTasks: Bool = true
    @AppStorage("settings.highlightOverdueTasks") private var highlightOverdueTasks: Bool = true
    @AppStorage("settings.compactProjectCards") private var compactProjectCards: Bool = false

    @State private var showContactOptions: Bool = false

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
                            "No exports yet",
                            systemImage: "square.and.arrow.up",
                            description: Text("Export and backup options can be added here later.")
                        )
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.blue)
                            Text("Export Data")
                        }
                    }

                    NavigationLink {
                        ContentUnavailableView(
                            "No integrations yet",
                            systemImage: "link",
                            description: Text("Connected services and sync options can be added here later.")
                        )
                    } label: {
                        HStack {
                            Image(systemName: "link")
                                .foregroundStyle(.blue)
                            Text("Integrations")
                        }
                    }
                } header: {
                    Text("Data - not yet implemented")
                }

                Section {
                    Button {
                        showContactOptions = true
                    } label: {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundStyle(.secondary)
                            Text("Contact the developer")
                        }
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
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow.gradient)
                            Text("Rate the app")
                        }
                    }
                    .buttonStyle(.plain)

                    if let appShareURL {
                        ShareLink(item: appShareURL) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.secondary)
                                Text("Share the app")
                            }
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
