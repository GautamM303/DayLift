//
//  MoodEntry.swift
//  DayLift
//
import Foundation

struct MoodEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    let mood: Mood

    init(id: UUID = UUID(), date: Date, mood: Mood) {
        self.id = id
        self.date = date.startOfDay
        self.mood = mood
    }
}
//  Created by Gautam Manerikar on 2026-01-10.
//

