//
//  SleepView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//

import SwiftUI

struct SleepView: View {
    @EnvironmentObject private var sleepVM: SleepViewModel

    @State private var hours: Double = 8.0
    @State private var quality: SleepQuality = .ok
    @State private var note: String = ""

    var body: some View {
        NavigationView {
            List {

                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Hours")
                            Spacer()
                            Text(String(format: "%.1f", hours))
                                .foregroundStyle(.secondary)
                        }

                        Slider(value: $hours, in: 0...14, step: 0.5)

                        Picker("Quality", selection: $quality) {
                            ForEach(SleepQuality.allCases) { q in
                                Text(q.rawValue).tag(q)
                            }
                        }

                        TextField("Note (optional)", text: $note)

                        Button("Save") {
                            sleepVM.upsertToday(hours: hours, quality: quality, note: note)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 6)

                } header: {
                    Text("Log last night")
                } footer: {
                    Text("Sleep tracking is for awareness and healthier routines — not perfection.")
                }

                Section {
                    if sleepVM.entries.isEmpty {
                        Text("No sleep logs yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(sleepVM.entries) { e in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(e.date.shortDisplay)
                                    .font(.headline)
                                Text(String(format: "%.1f hours • %@", e.hours, e.quality.rawValue))
                                    .foregroundStyle(.secondary)
                                if !e.note.isEmpty {
                                    Text(e.note)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { idxSet in
                            for idx in idxSet {
                                sleepVM.deleteEntry(sleepVM.entries[idx])
                            }
                        }
                    }
                } header: {
                    Text("History")
                }
            }
            .navigationTitle("Sleep")
            .onAppear {
                if let today = sleepVM.sleepForToday() {
                    hours = today.hours
                    quality = today.quality
                    note = today.note
                }
            }
        }
    }
}

