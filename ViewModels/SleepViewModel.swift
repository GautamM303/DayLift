//
//  SleepViewModel.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//

import Foundation

@MainActor
final class SleepViewModel: ObservableObject {
    @Published private(set) var entries: [SleepEntry] = []

    private let storage = StorageService.shared

    init() {
        load()
    }

    private func load() {
        entries = storage.loadCodable([SleepEntry].self,
                                      key: Constants.StorageKeys.sleepEntries,
                                      default: [])
        entries.sort { $0.date > $1.date }
    }

    private func save() {
        storage.saveCodable(entries, key: Constants.StorageKeys.sleepEntries)
    }

    func sleepFor(date: Date) -> SleepEntry? {
        let d = date.startOfDay
        return entries.first(where: { $0.date.isSameDay(as: d) })
    }

    func sleepForToday() -> SleepEntry? {
        sleepFor(date: Date())
    }

    func upsertToday(hours: Double, quality: SleepQuality, note: String) {
        let today = Date().startOfDay
        let clampedHours = max(0, min(14, hours))

        if let idx = entries.firstIndex(where: { $0.date.isSameDay(as: today) }) {
            entries[idx].hours = clampedHours
            entries[idx].quality = quality
            entries[idx].note = note
        } else {
            entries.append(SleepEntry(date: today, hours: clampedHours, quality: quality, note: note))
        }

        entries.sort { $0.date > $1.date }
        save()
    }

    func deleteEntry(_ entry: SleepEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    // MARK: - Summary helpers

    func lastNDays(_ n: Int) -> [SleepEntry] {
        let cutoff = Date().daysAgo(n - 1).startOfDay
        return entries.filter { $0.date >= cutoff }.sorted { $0.date < $1.date }
    }

    func sleepLoggedDaysLast7() -> Int {
        let cutoff = Date().daysAgo(6).startOfDay
        let days = Set(entries.filter { $0.date >= cutoff }.map { $0.date.startOfDay })
        return days.count
    }

    func sleepStreak() -> Int {
        let loggedDays = Set(entries.map { $0.date.startOfDay })
        var streak = 0
        var d = Date().startOfDay

        while loggedDays.contains(d) {
            streak += 1
            d = d.daysAgo(1).startOfDay
        }
        return streak
    }

    func avgSleepHoursLast7() -> Double {
        let days = (0..<7).map { Date().daysAgo(6 - $0).startOfDay }
        let map = Dictionary(uniqueKeysWithValues: entries.map { ($0.date.startOfDay, $0.hours) })

        let sum = days.reduce(0.0) { $0 + (map[$1] ?? 0.0) }
        return sum / 7.0
    }
}
