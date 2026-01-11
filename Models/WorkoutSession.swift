//
//  WorkoutSession.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import Foundation

struct WorkoutSession: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var templateId: UUID
    var templateName: String
    var startedAt: Date
    var endedAt: Date?
    var notes: String = ""
    var exercises: [ExerciseLog] = []

    var durationSeconds: Int {
        guard let endedAt else { return 0 }
        return max(0, Int(endedAt.timeIntervalSince(startedAt)))
    }

    var isActive: Bool { endedAt == nil }
}

struct ExerciseLog: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var sets: [WorkoutSet] = []
}

struct WorkoutSet: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var reps: Int
    var weightKg: Double
}
