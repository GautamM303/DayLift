//
//  NutritionViewModel.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//
import Foundation

@MainActor
final class NutritionViewModel: ObservableObject {
    @Published private(set) var entries: [NutritionEntry] = []

    private let storage = StorageService.shared

    init() {
        load()
    }

    private func load() {
        entries = storage.loadCodable([NutritionEntry].self,
                                     key: Constants.StorageKeys.nutritionEntries,
                                     default: [])
        entries.sort { $0.date > $1.date }
    }

    private func save() {
        storage.saveCodable(entries, key: Constants.StorageKeys.nutritionEntries)
    }

    func addEntry(_ entry: NutritionEntry) {
        entries.append(entry)
        entries.sort { $0.date > $1.date }
        save()
    }

    func deleteEntry(_ entry: NutritionEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func entriesForToday() -> [NutritionEntry] {
        let today = Date().startOfDay
        return entries.filter { $0.date.isSameDay(as: today) }
    }

    func totalsFor(date: Date) -> (cal: Int, p: Int, c: Int, f: Int) {
        let day = date.startOfDay
        let dayEntries = entries.filter { $0.date.isSameDay(as: day) }
        let cal = dayEntries.reduce(0) { $0 + $1.calories }
        let p = dayEntries.reduce(0) { $0 + $1.proteinG }
        let c = dayEntries.reduce(0) { $0 + $1.carbsG }
        let f = dayEntries.reduce(0) { $0 + $1.fatG }
        return (cal, p, c, f)
    }

    func lastNDaysTotals(_ n: Int) -> [(date: Date, calories: Int)] {
        (0..<n).map { offset in
            let d = Date().daysAgo(n - 1 - offset).startOfDay
            return (d, totalsFor(date: d).cal)
        }
    }

    // MARK: - New: Streaks & Summary helpers

    /// Consecutive days up to today where at least one nutrition entry exists.
    func nutritionStreak() -> Int {
        let loggedDays = Set(entries.map { $0.date.startOfDay })
        var streak = 0
        var d = Date().startOfDay

        while loggedDays.contains(d) {
            streak += 1
            d = d.daysAgo(1).startOfDay
        }
        return streak
    }

    /// How many of the last 7 days have at least one entry.
    func nutritionLoggedDaysLast7() -> Int {
        let cutoff = Date().daysAgo(6).startOfDay
        let days = Set(entries.filter { $0.date >= cutoff }.map { $0.date.startOfDay })
        return days.count
    }

    /// Average calories over the last 7 days (0 for days with no logs).
    func avgCaloriesLast7() -> Int {
        let points = lastNDaysTotals(7)
        let sum = points.reduce(0) { $0 + $1.calories }
        return Int(Double(sum) / 7.0)
    }
}


