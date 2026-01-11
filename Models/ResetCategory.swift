//
//  ResetCategory.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import Foundation

enum ResetCategory: String, CaseIterable, Codable {
    case breathing = "Breathing"
    case stretch = "Stretch"
    case movement = "Movement"
}

struct ResetStep: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var seconds: Int
    var detail: String

    init(id: UUID = UUID(), title: String, seconds: Int, detail: String) {
        self.id = id
        self.title = title
        self.seconds = seconds
        self.detail = detail
    }
}

struct ResetRoutine: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var category: ResetCategory
    var systemImage: String
    var steps: [ResetStep]

    init(id: UUID = UUID(), title: String, category: ResetCategory, systemImage: String, steps: [ResetStep]) {
        self.id = id
        self.title = title
        self.category = category
        self.systemImage = systemImage
        self.steps = steps
    }

    var totalSeconds: Int { steps.reduce(0) { $0 + $1.seconds } }

    static func defaults() -> [ResetRoutine] {
        [
            ResetRoutine(
                title: "2-Minute Calm Breath",
                category: .breathing,
                systemImage: "wind",
                steps: [
                    ResetStep(title: "Inhale", seconds: 4, detail: "Breathe in through your nose."),
                    ResetStep(title: "Hold", seconds: 2, detail: "Soft shoulders, relaxed jaw."),
                    ResetStep(title: "Exhale", seconds: 6, detail: "Slow exhale — let tension drop."),
                    ResetStep(title: "Repeat", seconds: 108, detail: "Continue the 4-2-6 rhythm.")
                ]
            ),
            ResetRoutine(
                title: "2-Minute Desk Stretch",
                category: .stretch,
                systemImage: "figure.cooldown",
                steps: [
                    ResetStep(title: "Neck stretch", seconds: 25, detail: "Gently tilt ear toward shoulder. Switch halfway."),
                    ResetStep(title: "Shoulder rolls", seconds: 25, detail: "Big slow circles. Switch direction halfway."),
                    ResetStep(title: "Chest opener", seconds: 30, detail: "Hands behind back or on chair. Lift chest gently."),
                    ResetStep(title: "Upper back hug", seconds: 40, detail: "Hug yourself and round upper back. Breathe slow.")
                ]
            ),
            ResetRoutine(
                title: "2-Minute Energy Boost",
                category: .movement,
                systemImage: "figure.walk",
                steps: [
                    ResetStep(title: "March in place", seconds: 40, detail: "Light marching. Breathe normally."),
                    ResetStep(title: "Wall push-ups", seconds: 40, detail: "Hands on wall, slow controlled reps."),
                    ResetStep(title: "Sit-to-stand", seconds: 40, detail: "Stand up and sit down slowly. Count your reps.")
                ]
            )
        ]
    }
}
