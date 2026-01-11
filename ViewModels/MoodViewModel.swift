//
//  MoodViewModel.swift
//  DayLift
//

import Foundation
import Combine

@MainActor
final class MoodViewModel: ObservableObject {
    @Published private(set) var entries: [MoodEntry] = []

    private let storage = StorageService.shared

    init() {
        load()
    }

    private func load() {
        entries = storage.loadCodable([MoodEntry].self,
                                     key: Constants.StorageKeys.moodEntries,
                                     default: [])
        entries.sort { $0.date > $1.date }
    }

    private func save() {
        storage.saveCodable(entries, key: Constants.StorageKeys.moodEntries)
    }

    func moodForToday() -> Mood? {
        let today = Date().startOfDay
        return entries.first(where: { $0.date.isSameDay(as: today) })?.mood
    }

    func setMoodForToday(_ mood: Mood) {
        let today = Date().startOfDay

        if let idx = entries.firstIndex(where: { $0.date.isSameDay(as: today) }) {
            entries[idx] = MoodEntry(id: entries[idx].id, date: today, mood: mood)
        } else {
            entries.append(MoodEntry(date: today, mood: mood))
        }

        entries.sort { $0.date > $1.date }
        save()
    }

    func lastNDays(_ n: Int) -> [MoodEntry] {
        let cutoff = Date().daysAgo(n - 1).startOfDay
        return entries.filter { $0.date >= cutoff }.sorted { $0.date < $1.date }
    }

    // MARK: - New: Streaks & Summary helpers

    /// Consecutive days up to today where a mood entry exists.
    func moodStreak() -> Int {
        let loggedDays = Set(entries.map { $0.date.startOfDay })
        var streak = 0
        var d = Date().startOfDay

        while loggedDays.contains(d) {
            streak += 1
            d = d.daysAgo(1).startOfDay
        }
        return streak
    }

    /// How many of the last 7 days have a mood logged.
    func moodLoggedDaysLast7() -> Int {
        let last7 = lastNDays(7)
        let days = Set(last7.map { $0.date.startOfDay })
        return days.count
    }
}


//  Created by Gautam Manerikar on 2026-01-10.
//

