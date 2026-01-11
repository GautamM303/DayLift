//
//  ProfileSetupSheet.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//
import SwiftUI

struct ProfileSetupSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileVM: ProfileViewModel

    @State private var age: Int = 18
    @State private var weightKg: Double = 70
    @State private var heightCm: Double = 175
    @State private var sex: BiologicalSex = .unspecified
    @State private var activity: ActivityLevel = .moderate
    @State private var goal: CalorieGoal = .maintain

    @State private var currentStep = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ProgressView(value: Double(currentStep + 1), total: 5)
                    .padding()

                TabView(selection: $currentStep) {
                    WelcomeStep()
                        .tag(0)

                    AgeWeightStep(age: $age, weightKg: $weightKg)
                        .tag(1)

                    HeightSexStep(heightCm: $heightCm, sex: $sex)
                        .tag(2)

                    ActivityGoalStep(activity: $activity, goal: $goal)
                        .tag(3)

                    SummaryStep(
                        age: age,
                        weightKg: weightKg,
                        heightCm: heightCm,
                        sex: sex,
                        activity: activity,
                        goal: goal,
                        recommendedCalories: profileVM.recommendedCalories()
                    )
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 15) {
                    if currentStep > 0 {
                        Button {
                            withAnimation { currentStep -= 1 }
                        } label: {
                            Text("Back")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray5))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    }

                    Button {
                        if currentStep < 4 {
                            withAnimation { currentStep += 1 }
                        } else {
                            saveProfile()
                        }
                    } label: {
                        Text(currentStep == 4 ? "Finish" : "Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isStepValid() ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!isStepValid())
                }
                .padding()
            }
            .navigationTitle("Set up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .interactiveDismissDisabled()
        .onAppear {
            // preload from existing saved profile
            let p = profileVM.profile
            age = p.age
            weightKg = p.weightKg
            heightCm = p.heightCm
            sex = p.sex
            activity = p.activity
            goal = p.goal
        }
    }

    private func isStepValid() -> Bool {
        switch currentStep {
        case 0: return true
        case 1: return age >= 13 && weightKg > 0
        case 2: return heightCm > 0
        case 3: return true
        case 4: return true
        default: return false
        }
    }

    private func saveProfile() {
        profileVM.profile = UserProfile(
            heightCm: heightCm,
            weightKg: weightKg,
            age: age,
            sex: sex,
            activity: activity,
            goal: goal
        )
        dismiss()
    }
}

// MARK: - Steps

private struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 18) {
            Text("🎯").font(.system(size: 72))
            Text("Welcome to DayLift")
                .font(.largeTitle).bold()
            Text("Let’s set up a few basics so we can estimate your daily calories for wellness tracking.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 40)
    }
}

private struct AgeWeightStep: View {
    @Binding var age: Int
    @Binding var weightKg: Double

    var body: some View {
        VStack(spacing: 24) {
            Text("Age & weight").font(.title).bold()

            VStack(alignment: .leading, spacing: 10) {
                Text("Age").font(.headline)

                Stepper("\(age) years", value: $age, in: 13...120)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Weight (kg)").font(.headline)

                HStack {
                    TextField("70", value: $weightKg, format: .number)
                        .keyboardType(.decimalPad)
                    Text("kg").foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 40)
    }
}

private struct HeightSexStep: View {
    @Binding var heightCm: Double
    @Binding var sex: BiologicalSex

    var body: some View {
        VStack(spacing: 24) {
            Text("Height & sex").font(.title).bold()

            VStack(alignment: .leading, spacing: 10) {
                Text("Height (cm)").font(.headline)

                HStack {
                    TextField("175", value: $heightCm, format: .number)
                        .keyboardType(.decimalPad)
                    Text("cm").foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Sex").font(.headline)

                Picker("Sex", selection: $sex) {
                    ForEach(BiologicalSex.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 40)
    }
}

private struct ActivityGoalStep: View {
    @Binding var activity: ActivityLevel
    @Binding var goal: CalorieGoal

    var body: some View {
        VStack(spacing: 18) {
            Text("Activity & goal").font(.title).bold()

            Text("This helps estimate your daily calories.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            VStack(alignment: .leading, spacing: 10) {
                Text("Activity level").font(.headline)

                Picker("Activity", selection: $activity) {
                    ForEach(ActivityLevel.allCases) { a in
                        Text(a.rawValue).tag(a)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal, 40)

            VStack(alignment: .leading, spacing: 10) {
                Text("Goal").font(.headline)

                Picker("Goal", selection: $goal) {
                    ForEach(CalorieGoal.allCases) { g in
                        Text(g.rawValue).tag(g)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.top, 30)
    }
}

private struct SummaryStep: View {
    let age: Int
    let weightKg: Double
    let heightCm: Double
    let sex: BiologicalSex
    let activity: ActivityLevel
    let goal: CalorieGoal
    let recommendedCalories: Int

    var body: some View {
        VStack(spacing: 18) {
            Text("✅").font(.system(size: 60))
            Text("All set!").font(.title).bold()

            VStack(alignment: .leading, spacing: 10) {
                Text("Your estimated daily calories")
                    .font(.headline)

                Text("\(recommendedCalories) kcal/day")
                    .font(.title2).bold()

                Text("This is a general estimate for wellness tracking, not medical advice.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.top, 40)
    }
}
