//
//  InsightsView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//
import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var moodVM: MoodViewModel
    @EnvironmentObject private var nutritionVM: NutritionViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Theme.card(moodStripCard())
                    Theme.card(caloriesProgressCard())
                    Theme.card(quickInsightCard())
                }
                .padding()
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Insights")
        }
    }

    private func moodStripCard() -> some View {
        let last7 = moodVM.lastNDays(7)
        let map = Dictionary(uniqueKeysWithValues: last7.map { ($0.date.startOfDay, $0.mood) })
        let days = (0..<7).map { Date().daysAgo(6 - $0).startOfDay }

        return VStack(alignment: .leading, spacing: 10) {
            Text("Mood (last 7 days)")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)

            HStack(spacing: 10) {
                ForEach(days, id: \.self) { d in
                    VStack(spacing: 6) {
                        Text(d.weekdayShort)
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                        Text(map[d]?.emoji ?? "—")
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            if last7.isEmpty {
                Text("Log your mood to see patterns here.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }

    private func caloriesProgressCard() -> some View {
        let rec = profileVM.recommendedCalories()
        let days = (0..<7).map { Date().daysAgo(6 - $0).startOfDay }

        return VStack(alignment: .leading, spacing: 10) {
            Text("Calories (last 7 days)")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)

            ForEach(days, id: \.self) { d in
                let cal = nutritionVM.totalsFor(date: d).cal

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(d.weekdayShort)
                            .frame(width: 40, alignment: .leading)
                            .foregroundStyle(Theme.textSecondary)

                        Text("\(cal) kcal")
                            .foregroundStyle(Theme.textPrimary)

                        Spacer()

                        Text("Goal \(rec)")
                            .font(.footnote)
                            .foregroundStyle(Theme.textSecondary)
                    }

                    ProgressView(
                        value: Double(min(cal, rec)),
                        total: Double(max(rec, 1))
                    )
                }
            }

            Text("Estimates are okay — awareness beats perfection.")
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private func quickInsightCard() -> some View {
        let todayMood = moodVM.moodForToday()
        let todayCals = nutritionVM.totalsFor(date: Date()).cal
        let rec = profileVM.recommendedCalories()

        let message: String = {
            if let m = todayMood, m.isNegative {
                return "If today feels heavy, try the Breathe tab for a quick reset — small actions count."
            }
            if todayCals == 0 {
                return "No nutrition logged today. Even a rough estimate helps you spot patterns over time."
            }
            if todayCals < rec - 400 {
                return "You’re far below your estimate today. If that wasn’t intentional, consider a balanced snack."
            }
            if todayCals > rec + 400 {
                return "You’re above your estimate today. No stress — hydration and a short walk can help you feel better."
            }
            return "You’re tracking consistently — that’s the hardest part. Keep it sustainable."
        }()

        return VStack(alignment: .leading, spacing: 8) {
            Text("One simple insight")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)

            Text(message)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}
