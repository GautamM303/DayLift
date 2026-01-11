//
//  NutritionEntry.swift
//  DayLift
//
import Foundation

struct NutritionEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date

    var calories: Int
    var proteinG: Int
    var carbsG: Int
    var fatG: Int
    var note: String

    init(
        id: UUID = UUID(),
        date: Date,
        calories: Int,
        proteinG: Int = 0,
        carbsG: Int = 0,
        fatG: Int = 0,
        note: String = ""
    ) {
        self.id = id
        self.date = date.startOfDay
        self.calories = max(0, calories)
        self.proteinG = max(0, proteinG)
        self.carbsG = max(0, carbsG)
        self.fatG = max(0, fatG)
        self.note = note
    }
}

//  Created by Gautam Manerikar on 2026-01-10.
//

