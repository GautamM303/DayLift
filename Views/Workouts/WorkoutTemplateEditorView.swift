//
//  WorkoutTemplateEditorView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import SwiftUI

struct WorkoutTemplateEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutVM: WorkoutViewModel

    let templateId: UUID

    @State private var name: String = ""
    @State private var exercises: [ExerciseTemplate] = []

    @State private var newExerciseName = ""
    @State private var newExerciseNotes = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Workout") {
                    TextField("Name", text: $name)
                }

                Section("Add Exercise") {
                    TextField("Exercise name", text: $newExerciseName)
                    TextField("Notes (optional)", text: $newExerciseNotes)

                    Button("Add Exercise") {
                        let ex = ExerciseTemplate(
                            name: newExerciseName.trimmingCharacters(in: .whitespacesAndNewlines),
                            notes: newExerciseNotes.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        exercises.append(ex)
                        newExerciseName = ""
                        newExerciseNotes = ""
                    }
                    .disabled(newExerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Section("Exercises") {
                    if exercises.isEmpty {
                        Text("No exercises yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(exercises) { ex in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ex.name)
                                if !ex.notes.isEmpty {
                                    Text(ex.notes).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { idx in exercises.remove(atOffsets: idx) }
                    }
                }
            }
            .navigationTitle("Edit Workout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = WorkoutTemplate(
                            id: templateId,
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            exercises: exercises,
                            createdAt: workoutVM.templates.first(where: { $0.id == templateId })?.createdAt ?? Date()
                        )
                        workoutVM.updateTemplate(updated)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let t = workoutVM.templates.first(where: { $0.id == templateId }) {
                    name = t.name
                    exercises = t.exercises
                }
            }
        }
    }
}
