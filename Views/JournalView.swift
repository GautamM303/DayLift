//
//  JournalView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import SwiftUI

struct JournalView: View {
    @EnvironmentObject private var journalVM: JournalViewModel
    @State private var showAdd = false
    @State private var showClearConfirm = false
    @State private var query: String = ""

    var body: some View {
        NavigationView {
            List {
                if filteredEntries.isEmpty {
                    Text(query.isEmpty ? "No journal entries yet." : "No results.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filteredEntries) { e in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(e.date.shortDisplay)
                                .font(.headline)

                            Text(e.text)
                                .lineLimit(3)
                                .foregroundStyle(.primary)

                            if !e.tags.isEmpty {
                                Text(e.tags.map { "#\($0)" }.joined(separator: " "))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { idxSet in
                        for idx in idxSet {
                            journalVM.delete(filteredEntries[idx])
                        }
                    }
                }

                if !journalVM.entries.isEmpty {
                    Section {
                        Button(role: .destructive) {
                            showClearConfirm = true
                        } label: {
                            Label("Clear Journal", systemImage: "trash")
                        }
                    } footer: {
                        Text("This deletes all journal entries. This can’t be undone.")
                    }
                }
            }
            .navigationTitle("Journal")
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddJournalEntryView(
                    title: "New Entry",
                    prompt: "Write one sentence. Keep it simple."
                )
                .environmentObject(journalVM)
            }
            .alert("Clear all journal entries?", isPresented: $showClearConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    journalVM.clearAll()
                }
            } message: {
                Text("This can’t be undone.")
            }
        }
    }

    private var filteredEntries: [JournalEntry] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return journalVM.entries }

        return journalVM.entries.filter { e in
            e.text.lowercased().contains(q) || e.tags.contains(where: { $0.lowercased().contains(q) })
        }
    }
}
