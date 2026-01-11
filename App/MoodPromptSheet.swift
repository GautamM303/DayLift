//
//  MoodPromptSheet.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import SwiftUI

struct MoodPromptSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var moodVM: MoodViewModel

    @State private var selectedMood: Mood? = nil

    // Callbacks from RootTabView (optional)
    var onGoToBreathe: (() -> Void)? = nil
    var onGoToJournal: (() -> Void)? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How are you feeling today?")
                    .font(.title2).bold()

                MoodPickerBar(selected: $selectedMood) { mood in
                    moodVM.setMoodForToday(mood)
                }

                if let mood = selectedMood ?? moodVM.moodForToday() {
                    Text("Today: \(mood.emoji) \(mood.label)")
                        .font(.headline)

                    if mood.isNegative {
                        // ✅ FIX: Pass onGoToJournal to SupportActionsView as required
                        SupportActionsView(
                            onGoToBreathe: {
                                onGoToBreathe?()
                                dismiss()
                            },
                            onGoToJournal: {
                                onGoToJournal?()
                                dismiss()
                            }
                        )
                    } else {
                        Text("Nice — keep it going with one small healthy step today.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Tap an emoji to log your mood. You can change it any time today.")
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Daily Check-In")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                selectedMood = moodVM.moodForToday()
            }
        }
    }
}
