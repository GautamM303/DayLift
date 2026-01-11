//
//  UserProfile.swift
//  DayLift
import Foundation

enum BiologicalSex: String, CaseIterable, Codable, Identifiable {
    case male = "Male"
    case female = "Female"
    case unspecified = "Unspecified"

    var id: String { rawValue }
}

enum ActivityLevel: String, CaseIterable, Codable, Identifiable {
    case sedentary = "Sedentary"
    case light = "Light"
    case moderate = "Moderate"
    case active = "Active"
    case veryActive = "Very Active"

    var id: String { rawValue }

    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .veryActive: return 1.9
        }
    }
}

enum CalorieGoal: String, CaseIterable, Codable, Identifiable {
    case lose = "Lose weight"
    case maintain = "Maintain"
    case gain = "Gain weight"

    var id: String { rawValue }

    /// Simple safe adjustment for demo purposes
    var adjustment: Int {
        switch self {
        case .lose: return -300
        case .maintain: return 0
        case .gain: return 300
        }
    }
}

struct UserProfile: Codable, Equatable {
    var heightCm: Double
    var weightKg: Double
    var age: Int
    var sex: BiologicalSex
    var activity: ActivityLevel
    var goal: CalorieGoal

    static let `default` = UserProfile(
        heightCm: 175,
        weightKg: 70,
        age: 18,
        sex: .unspecified,
        activity: .moderate,
        goal: .maintain
    )
}

//  Created by Gautam Manerikar on 2026-01-10.
//

