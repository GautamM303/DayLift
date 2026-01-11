//
//  WorkoutSessionView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import SwiftUI

struct WorkoutSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutVM: WorkoutViewModel

    let sessionId: UUID

    @State private var showAddSet = false
    @State private var selectedExerciseIndex: Int = 0

    @State private var reps: Int = 10
    @State private var weightKg: Double = 20

    var session: WorkoutSession? {
        workoutVM.sessions.first(where: { $0.id == sessionId })
    }

    var body: some View {
        Group {
            if let s = session {
                List {
                    Section {
                        HStack {
                            Text("Started")
                            Spacer()
                            Text(s.startedAt.formatted(date: .abbreviated, time: .shortened))
                                .foregroundStyle(.secondary)
                        }
                        if let ended = s.endedAt {
                            HStack {
                                Text("Ended")
                                Spacer()
                                Text(ended.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundStyle(.secondary)
                            }
                            HStack {
                                Text("Duration")
                                Spacer()
                                Text("\(s.durationSeconds / 60)m \(s.durationSeconds % 60)s")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    ForEach(Array(s.exercises.enumerated()), id: \.offset) { idx, ex in
                        Section(ex.name) {
                            if ex.sets.isEmpty {
                                Text("No sets yet. Tap Add Set.")
                                    .foregroundStyle(.secondary)
                            } else {
                                ForEach(ex.sets) { set in
                                    HStack {
                                        Text("\(set.reps) reps")
                                        Spacer()
                                        Text(String(format: "%.1f kg", set.weightKg))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .onDelete { offsets in
                                    for o in offsets {
                                        workoutVM.deleteSet(sessionId: s.id, exerciseIndex: idx, setId: ex.sets[o].id)
                                    }
                                }
                            }

                            Button {
                                selectedExerciseIndex = idx
                                showAddSet = true
                            } label: {
                                Label("Add Set", systemImage: "plus.circle")
                            }
                        }
                    }

                    Section {
                        if s.isActive {
                            Button(role: .destructive) {
                                workoutVM.endSession(s.id)
                                dismiss()
                            } label: {
                                Label("Finish Workout", systemImage: "checkmark.circle.fill")
                            }
                        } else {
                            Text("Workout completed ✅")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle(s.templateName)
                .sheet(isPresented: $showAddSet) {
                    NavigationView {
                        Form {
                            Section("Set") {
                                Stepper("Reps: \(reps)", value: $reps, in: 1...200)
                                HStack {
                                    Text("Weight (kg)")
                                    Spacer()
                                    TextField("20", value: $weightKg, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 120)
                                }
                            }
                        }
                        .navigationTitle("Add Set")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") { showAddSet = false }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    workoutVM.addSet(sessionId: s.id,
                                                     exerciseIndex: selectedExerciseIndex,
                                                     reps: reps,
                                                     weightKg: weightKg)
                                    showAddSet = false
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Session not found")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
