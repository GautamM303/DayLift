//
//  SupportActionsView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import SwiftUI

struct SupportActionsView: View {
    @EnvironmentObject private var journalVM: JournalViewModel

    var onGoToBreathe: () -> Void
    var onGoToJournal: () -> Void

    @State private var showAddJournal = false
    @State private var showReset = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Try one small action")
                .font(.headline)

            Button {
                onGoToBreathe()
            } label: {
                actionRow(
                    icon: "wind",
                    title: "1-minute breathing",
                    subtitle: "Quick calm reset"
                )
            }

            Button {
                showReset = true
            } label: {
                actionRow(
                    icon: "figure.cooldown",
                    title: "2-minute reset",
                    subtitle: "Specific stretches or mini-moves"
                )
            }
            .sheet(isPresented: $showReset) {
                TwoMinuteResetView()
            }

            Button {
                showAddJournal = true
            } label: {
                actionRow(
                    icon: "pencil.and.outline",
                    title: "One-sentence journal",
                    subtitle: "Name what’s going on"
                )
            }
            .sheet(isPresented: $showAddJournal) {
                AddJournalEntryView(
                    title: "One-sentence journal",
                    prompt: "Write one sentence. Example: “I feel ___ because ___. Next, I’ll ___.”"
                )
                .environmentObject(journalVM)
            }

            Button {
                onGoToJournal()
            } label: {
                actionRow(
                    icon: "book.closed",
                    title: "View your journal",
                    subtitle: "See entries and search"
                )
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
    }

    private func actionRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.primary.opacity(0.06))
        .cornerRadius(12)
    }
}

