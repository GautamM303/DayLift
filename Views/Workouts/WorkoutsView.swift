//
//  WorkoutsView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject private var workoutVM: WorkoutViewModel

    @State private var showNewTemplate = false
    @State private var newName = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Strength and movement support energy, mood, and long-term health.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Templates") {
                    if workoutVM.templates.isEmpty {
                        Text("No workouts yet. Tap + to create one.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(workoutVM.templates) { t in
                            NavigationLink(destination: WorkoutTemplateDetailView(templateId: t.id)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(t.name).font(.headline)
                                    Text("\(t.exercises.count) exercise(s)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { idx in
                            for i in idx { workoutVM.deleteTemplate(workoutVM.templates[i]) }
                        }
                    }
                }

                Section("History") {
                    NavigationLink(destination: WorkoutHistoryView()) {
                        Text("View workout history")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showNewTemplate = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showNewTemplate) {
                NavigationView {
                    Form {
                        Section("Workout Name") {
                            TextField("e.g., Push Day", text: $newName)
                        }
                    }
                    .navigationTitle("New Workout")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showNewTemplate = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Create") {
                                workoutVM.addTemplate(name: newName.trimmingCharacters(in: .whitespacesAndNewlines))
                                newName = ""
                                showNewTemplate = false
                            }
                            .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }
}
