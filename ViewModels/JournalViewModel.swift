//
//  JournalViewModel.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import Foundation

@MainActor
final class JournalViewModel: ObservableObject {
    @Published private(set) var entries: [JournalEntry] = []

    private let storage = StorageService.shared

    init() {
        load()
    }

    private func load() {
        entries = storage.loadCodable([JournalEntry].self,
                                      key: Constants.StorageKeys.journalEntries,
                                      default: [])
        entries.sort { $0.date > $1.date }
    }


    private func save() {
        storage.saveCodable(entries, key: Constants.StorageKeys.journalEntries)
    }

    func addEntry(text: String, tags: [String]) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        entries.insert(JournalEntry(text: trimmed, tags: tags), at: 0)
        save()
    }

    func delete(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func clearAll() {
        entries.removeAll()
        save()
    }
}

// NOTE: Xcode sometimes autocompletes weird names; keep this helper clean.
private extension JournalViewModel {
    func loadScaffold() { /* unused */ }
}
