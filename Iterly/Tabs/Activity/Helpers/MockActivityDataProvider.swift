//
//  MockActivityDataProvider.swift
//  Iterly
//
//  Created by Filippo Cilia on 30/03/2026.
//

import Foundation

struct MockActivityDataProvider: ActivityDataProviding {
    func events(
        for range: ActivityRange,
        now: Date,
        projects: [Project],
        tasks: [ProjectTask],
        calendar: Calendar
    ) -> [ActivityEvent] {
        let interval = range.dateInterval(relativeTo: now, calendar: calendar)

        let projectEvents = projects.flatMap { project in
            makeProjectEvents(project, in: interval, calendar: calendar)
        }
        let taskEvents = tasks.flatMap { task in
            makeTaskEvents(task, in: interval, calendar: calendar)
        }

        return (projectEvents + taskEvents)
            .sorted { lhs, rhs in
                if lhs.date != rhs.date {
                    return lhs.date < rhs.date
                }

                if lhs.kind != rhs.kind {
                    return lhs.kind.rawValue < rhs.kind.rawValue
                }

                return lhs.title < rhs.title
            }
    }

    private func makeProjectEvents(
        _ project: Project,
        in interval: DateInterval,
        calendar: Calendar
    ) -> [ActivityEvent] {
        let seed = stableSeed(for: project.id.uuidString)
        let cadence = 43 + (seed % 24)
        let phase = seed % cadence
        let recurringDates = recurringDates(
            from: interval.start,
            within: interval,
            cadence: cadence,
            phase: phase,
            calendar: calendar
        )

        let actualDates = [project.creationDate, project.lastUpdated]
            .filter { interval.contains($0) }
            .map { calendar.startOfDay(for: $0) }

        let dates = Array(Set(recurringDates + actualDates))
            .sorted()

        return dates.map { date in
            ActivityEvent(
                date: date,
                kind: .project,
                title: project.title,
                context: project.status.title
            )
        }
    }

    private func makeTaskEvents(
        _ task: ProjectTask,
        in interval: DateInterval,
        calendar: Calendar
    ) -> [ActivityEvent] {
        let seed = stableSeed(for: task.id.uuidString)
        let cadence = cadence(for: task.status, seed: seed)
        let phase = (seed / 3) % cadence
        let recurringDates = recurringDates(
            from: interval.start,
            within: interval,
            cadence: cadence,
            phase: phase,
            calendar: calendar
        )

        let actualDates = [task.creationDate]
            .filter { interval.contains($0) }
            .map { calendar.startOfDay(for: $0) }

        let dates = Array(Set(recurringDates + actualDates))
            .sorted()

        return dates.map { date in
            ActivityEvent(
                date: date,
                kind: .task,
                title: task.title,
                context: task.project.title
            )
        }
    }

    private func cadence(for status: TaskStatus, seed: Int) -> Int {
        switch status {
        case .done:
            16 + (seed % 10)
        case .inProgress:
            20 + (seed % 12)
        case .blocked:
            34 + (seed % 14)
        case .notStarted:
            45 + (seed % 16)
        case .closed:
            38 + (seed % 12)
        }
    }

    private func recurringDates(
        from startDate: Date,
        within interval: DateInterval,
        cadence: Int,
        phase: Int,
        calendar: Calendar
    ) -> [Date] {
        let firstDay = calendar.startOfDay(for: max(startDate, interval.start))
        let endDay = calendar.startOfDay(for: interval.end)
        let totalDays = calendar.dateComponents([.day], from: firstDay, to: endDay).day ?? 0

        guard totalDays >= 0 else { return [] }

        var days: [Date] = []
        var offset = phase

        while offset <= totalDays {
            if let date = calendar.date(byAdding: .day, value: offset, to: firstDay) {
                days.append(date)
            }
            offset += cadence
        }

        if days.isEmpty {
            days.append(firstDay)
        }

        return days
    }

    private func stableSeed(for value: String) -> Int {
        value.unicodeScalars.reduce(0) { partialResult, scalar in
            ((partialResult * 31) + Int(scalar.value)) % 104_729
        }
    }
}
