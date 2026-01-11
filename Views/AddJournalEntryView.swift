//
//  AddJournalEntryView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import SwiftUI

struct AddJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var journalVM: JournalViewModel

    let title: String
    let prompt: String

    @State private var text: String = ""
    @State private var tagsText: String = ""   // comma separated

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text(prompt)
                    .font(.headline)

                TextEditor(text: $text)
                    .frame(minHeight: 180)
                    .padding(10)
                    .background(Color.primary.opacity(0.06))
                    .cornerRadius(12)

                TextField("Tags (optional, comma-separated)", text: $tagsText)
                    .textInputAutocapitalization(.never)
                    .padding(12)
                    .background(Color.primary.opacity(0.06))
                    .cornerRadius(12)

                Text("Tip: name the feeling + what you need next.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let tags = tagsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        journalVM.addEntry(text: text, tags: tags)
                        dismiss()
                    }
                }
            }
        }
    }
}
