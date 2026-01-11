//
//  HealthSummaryCardView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import SwiftUI

struct HealthSummaryCardView: View {
    let moodLoggedDays: Int
    let moodStreak: Int

    let nutritionLoggedDays: Int
    let nutritionStreak: Int
    let avgCalories: Int
    let goalCalories: Int

    let workoutsThisWeek: Int
    let workoutStreak: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Health Summary")
                .font(.headline)

            // Streak row
            HStack(spacing: 10) {
                streakPill("Mood", moodStreak)
                streakPill("Nutrition", nutritionStreak)
                streakPill("Workouts", workoutStreak)
            }

            Divider().opacity(0.4)

            // Counts row
            VStack(alignment: .leading, spacing: 6) {
                Text("Logged this week")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("Mood: \(moodLoggedDays)/7")
                    Spacer()
                    Text("Nutrition: \(nutritionLoggedDays)/7")
                }
                .font(.subheadline)

                HStack {
                    Text("Workouts: \(workoutsThisWeek)")
                    Spacer()
                }
                .font(.subheadline)
            }

            Divider().opacity(0.4)

            // Calories summary
            VStack(alignment: .leading, spacing: 6) {
                Text("Calories")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Avg: \(avgCalories) kcal • Goal: \(goalCalories) kcal")
                    .font(.subheadline)

                ProgressView(
                    value: Double(min(avgCalories, goalCalories)),
                    total: Double(max(goalCalories, 1))
                )
            }

            Text("These are general wellness estimates, not medical advice.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
    }

    private func streakPill(_ title: String, _ days: Int) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("🔥 \(days)d")
                .font(.caption).bold()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Color.primary.opacity(0.07))
        .cornerRadius(999)
    }
}
