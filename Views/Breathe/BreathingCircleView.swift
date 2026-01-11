//
//  BreathingCircleView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import SwiftUI

struct BreathingCircleView: View {
    let phase: BreathPhase
    let progress: Double

    var body: some View {
        // scale grows on inhale, stays on hold, shrinks on exhale
        let scale: Double = {
            switch phase {
            case .inhale:
                return 0.6 + 0.6 * progress
            case .hold:
                return 1.2
            case .exhale:
                return 1.2 - 0.6 * progress
            }
        }()

        ZStack {
            Circle()
                .fill(.thinMaterial)
                .frame(width: 220, height: 220)
                .scaleEffect(scale)
                .animation(.linear(duration: 0.02), value: scale)

            Circle()
                .strokeBorder(Color.primary.opacity(0.15), lineWidth: 2)
                .frame(width: 260, height: 260)

            Text("\(Int(progress * 100))%")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .accessibilityLabel("Breathing \(phase.rawValue)")
    }
}
