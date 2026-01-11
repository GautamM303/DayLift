//
//  SettingsView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var profileVM: ProfileViewModel

    var body: some View {
        NavigationView {
            Form {
                Section("Profile") {
                    HStack {
                        Text("Height (cm)")
                        Spacer()
                        TextField("175", value: $profileVM.profile.heightCm, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 90)
                    }

                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("70", value: $profileVM.profile.weightKg, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 90)
                    }

                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("18", value: $profileVM.profile.age, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                    }

                    Picker("Sex", selection: $profileVM.profile.sex) {
                        ForEach(BiologicalSex.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }

                    Picker("Activity", selection: $profileVM.profile.activity) {
                        ForEach(ActivityLevel.allCases) { a in
                            Text(a.rawValue).tag(a)
                        }
                    }

                    Picker("Goal", selection: $profileVM.profile.goal) {
                        ForEach(CalorieGoal.allCases) { g in
                            Text(g.rawValue).tag(g)
                        }
                    }
                }

                Section("Estimates") {
                    let bmi = profileVM.bmi()
                    let maintenance = profileVM.maintenanceCalories()
                    let recommended = profileVM.recommendedCalories()

                    HStack {
                        Text("BMI")
                        Spacer()
                        Text(bmi == 0 ? "-" : String(format: "%.1f", bmi))
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Maintenance")
                        Spacer()
                        Text("\(maintenance) kcal")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Recommended")
                        Spacer()
                        Text("\(recommended) kcal")
                            .fontWeight(.bold)
                    }

                    Text("These are general estimates for wellness tracking, not medical advice.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
