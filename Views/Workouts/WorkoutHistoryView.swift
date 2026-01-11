//
//  WorkoutHistoryView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject private var workoutVM: WorkoutViewModel
    @State private var showClearConfirm = false

    var body: some View {
        List {
            Section {
                if workoutVM.sessions.isEmpty {
                    Text("No workout history yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(workoutVM.sessions) { s in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(s.templateName).font(.headline)
                            Text(s.startedAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if s.endedAt != nil {
                                Text("Duration: \(s.durationSeconds / 60)m \(s.durationSeconds % 60)s")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("In progress…")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { idxSet in
                        // delete selected items
                        for idx in idxSet {
                            let sessionId = workoutVM.sessions[idx].id
                            workoutVM.deleteSession(sessionId)
                        }
                    }
                }
            }

            if !workoutVM.sessions.isEmpty {
                Section {
                    Button(role: .destructive) {
                        showClearConfirm = true
                    } label: {
                        Label("Clear History", systemImage: "trash")
                    }
                } footer: {
                    Text("This deletes all workout sessions from your history. Templates are not affected.")
                }
            }
        }
        .navigationTitle("History")
        .listStyle(.insetGrouped)
        .alert("Clear workout history?", isPresented: $showClearConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                workoutVM.clearHistory()
            }
        } message: {
            Text("This can’t be undone.")
        }
    }
}
