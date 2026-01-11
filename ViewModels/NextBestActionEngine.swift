//
//  NextBestActionEngine.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import Foundation

struct NextBestActionEngine {

    static func decide(
        mood: Mood?,
        sleepHours: Double?,
        caloriesToday: Int,
        calorieGoal: Int,
        didWorkoutToday: Bool,
        now: Date = Date()
    ) -> NextBestAction {

        let hour = Calendar.current.component(.hour, from: now)

        // 1) Low mood → immediate support
        if let mood, mood.isNegative {
            return NextBestAction(
                kind: .breathe,
                title: "Take 1 minute to reset",
                subtitle: "Try guided breathing to calm your body.",
                educational: "Slower breathing can help your body shift toward a calmer state.",
                systemImage: "wind",
                targetTab: .breathe
            )
        }

        // 2) Missing sleep log → morning/early day prompt
        if sleepHours == nil && hour <= 12 {
            return NextBestAction(
                kind: .logSleep,
                title: "Log last night’s sleep",
                subtitle: "Quick check-in helps spot patterns.",
                educational: "Consistent sleep routines can support energy, focus, and mood.",
                systemImage: "bed.double.fill",
                targetTab: .insights
            )
        }

        // 3) Low sleep → gentle recovery suggestion (non-medical)
        if let s = sleepHours, s > 0, s < 6.5 {
            return NextBestAction(
                kind: .hydrateReset,
                title: "Go easy today",
                subtitle: "Hydrate + a short walk can help you feel steadier.",
                educational: "After shorter sleep, light movement and hydration can support alertness.",
                systemImage: "drop.fill",
                targetTab: .insights
            )
        }

        // 4) No nutrition logs by later afternoon/evening
        if caloriesToday == 0 && hour >= 16 {
            return NextBestAction(
                kind: .logNutrition,
                title: "Log a rough estimate",
                subtitle: "Even a quick add helps you stay aware.",
                educational: "Tracking is about awareness — estimates are still useful.",
                systemImage: "fork.knife",
                targetTab: .nutrition
            )
        }

        // 5) No workout yet → tiny movement suggestion
        if !didWorkoutToday && hour >= 13 && hour <= 20 {
            return NextBestAction(
                kind: .quickWalk,
                title: "10-minute walk",
                subtitle: "A small movement break counts.",
                educational: "Light movement can support energy and mood — consistency matters most.",
                systemImage: "figure.walk",
                targetTab: .workouts
            )
        }

        // 6) Calories far below goal late day (if they are logging)
        if caloriesToday > 0 && caloriesToday < (calorieGoal - 400) && hour >= 16 {
            return NextBestAction(
                kind: .logNutrition,
                title: "Consider a balanced snack",
                subtitle: "Protein + carbs can support energy.",
                educational: "Balanced snacks can help stabilize energy through the day.",
                systemImage: "plus.circle.fill",
                targetTab: .nutrition
            )
        }

        // 7) Default positive reinforcement
        return NextBestAction(
            kind: .logMood,
            title: "Keep it sustainable",
            subtitle: "One small healthy step today is enough.",
            educational: "Small routines repeated over time beat big plans you can’t maintain.",
            systemImage: "sparkles",
            targetTab: .checkIn
        )
    }
}
