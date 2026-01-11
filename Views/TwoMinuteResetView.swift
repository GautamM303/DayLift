//
//  TwoMinuteResetView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import SwiftUI

struct TwoMinuteResetView: View {
    @Environment(\.dismiss) private var dismiss

    let routines: [ResetRoutine] = ResetRoutine.defaults()
    @State private var selected: ResetRoutine? = nil

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Pick a quick reset. Nothing intense — just something doable.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                ForEach(routines) { r in
                    Button {
                        selected = r
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: r.systemImage)
                                .frame(width: 26)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(r.title).font(.headline)
                                Text("\(r.category.rawValue) • \(r.totalSeconds)s")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("2-Minute Reset")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(item: $selected) { routine in
                ResetTimerView(routine: routine)
            }
        }
    }
}
