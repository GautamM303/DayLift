//
//  WorkoutTemplateDetailView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import SwiftUI

struct WorkoutTemplateDetailView: View {
    @EnvironmentObject private var workoutVM: WorkoutViewModel
    let templateId: UUID

    @State private var showEditor = false
    @State private var startSession = false
    @State private var createdSessionId: UUID?

    var template: WorkoutTemplate? {
        workoutVM.templates.first(where: { $0.id == templateId })
    }

    var body: some View {
        Group {
            if let t = template {
                List {
                    Section("Exercises") {
                        if t.exercises.isEmpty {
                            Text("Add exercises to this workout.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(t.exercises) { ex in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ex.name).font(.headline)
                                    if !ex.notes.isEmpty {
                                        Text(ex.notes).font(.subheadline).foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }

                    Section {
                        Button {
                            let session = workoutVM.startSession(for: t)
                            createdSessionId = session.id
                            startSession = true
                        } label: {
                            Label("Start Workout", systemImage: "play.fill")
                        }
                    }
                }
                .navigationTitle(t.name)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") { showEditor = true }
                    }
                }
                .sheet(isPresented: $showEditor) {
                    WorkoutTemplateEditorView(templateId: t.id)
                        .environmentObject(workoutVM)
                }
                .background(
                    NavigationLink(
                        destination: WorkoutSessionView(sessionId: createdSessionId ?? UUID()),
                        isActive: $startSession
                    ) { EmptyView() }
                    .hidden()
                )
            } else {
                Text("Workout not found")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
