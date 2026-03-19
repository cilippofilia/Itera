# Iterly

Iterly is a SwiftUI project tracker built with SwiftData. It focuses on keeping project work visible through pinned projects, upcoming tasks, and status-driven project sections.

## Features
- Home dashboard with pinned projects, upcoming tasks, and quick project summaries.
- Projects list with active and closed sections, pinning, and deletion.
- Project details with tasks, subtasks, releases, and status/priority metadata.
- Sample data seeding for previews and quick in-app demo content.

## Tech Stack
- SwiftUI for UI and navigation.
- SwiftData for persistence (`Project`, `ProjectTask`, `ProjectRelease`).
- `@Observable` view models for UI logic.

## Data Model
- `Project` includes status, priority, pinning, tasks, and an optional current release.
- `ProjectTask` supports due dates, priority, status, and nested subtasks.
- `ProjectRelease` stores version, build, and app URL metadata per project.

## Requirements
- Xcode with the iOS 26 SDK.
- Swift 6.2 or later.

## Run The App
1. Open `Iterly.xcodeproj`.
2. Select the `Iterly` scheme.
3. Run on an iOS 26 simulator or device.

## Sample Data
- Use the Home toolbar to add sample data to your current store.
- Use the Home toolbar to erase all data.
- Previews are seeded using `Iterly/Helpers/SampleData.swift`.

## Project Structure
- `Iterly/IterlyApp.swift` sets up the SwiftData container.
- `Iterly/ContentView.swift` defines the tab navigation.
- `Iterly/Tabs/Home` contains the Home dashboard.
- `Iterly/Tabs/Projects` contains project lists, details, and task flows.
- `Iterly/Helpers` includes shared UI components and utilities.
