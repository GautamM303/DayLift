//
//  WorkoutTemplate.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import Foundation

struct WorkoutTemplate: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var exercises: [ExerciseTemplate] = []
    var createdAt: Date = Date()
}

struct ExerciseTemplate: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var notes: String = ""
}
