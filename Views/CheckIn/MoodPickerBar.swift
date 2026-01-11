//
//  MoodPickerBar.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import SwiftUI
import UIKit

struct MoodPickerBar: View {
    @Binding var selected: Mood?
    var onSelect: (Mood) -> Void

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Mood.allCases) { mood in
                Button {
                    let h = UIImpactFeedbackGenerator(style: .light)
                    h.impactOccurred()

                    selected = mood
                    onSelect(mood)
                } label: {
                    Text(mood.emoji)
                        .font(.system(size: 34))
                        .padding(10)
                        .background(
                            Circle().fill(selected == mood ? Color.primary.opacity(0.12) : Color.clear)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Mood \(mood.label)")
            }
        }
        .padding(.vertical, 4)
    }
}

