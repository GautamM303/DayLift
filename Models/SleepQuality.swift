//
//  SleepQuality.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import Foundation

enum SleepQuality: String, CaseIterable, Codable, Identifiable {
    case poor = "Poor"
    case ok = "OK"
    case good = "Good"

    var id: String { rawValue }
}

struct SleepEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date          // stored as startOfDay
    var hours: Double       // 0...14
    var quality: SleepQuality
    var note: String

    init(
        id: UUID = UUID(),
        date: Date,
        hours: Double,
        quality: SleepQuality = .ok,
        note: String = ""
    ) {
        self.id = id
        self.date = date.startOfDay
        self.hours = max(0, min(14, hours))
        self.quality = quality
        self.note = note
    }
}
