//
//  BreatheView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//
import SwiftUI
import UIKit

enum BreathPhase: String {
    case inhale = "Inhale"
    case hold = "Hold"
    case exhale = "Exhale"
}

struct BreatheView: View {
    @State private var isRunning = false
    @State private var phase: BreathPhase = .inhale
    @State private var progress: Double = 0.0

    private let inhaleS: Double = 4
    private let holdS: Double = 2
    private let exhaleS: Double = 6

    @State private var currentDuration: Double = 4
    @State private var timer: Timer?

    var body: some View {
        NavigationView {
            VStack(spacing: 18) {
                Text("Guided Breathing")
                    .font(.title2).bold()

                BreathingCircleView(phase: phase, progress: progress)

                Text("\(phase.rawValue) • \(remainingSeconds())s")
                    .font(.title3).bold()

                Text("Inhale as it grows, exhale as it shrinks.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // ✅ NEW micro-copy
                Text("Longer exhales can help your body shift toward calm.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(isRunning ? "Stop" : "Start") {
                    isRunning ? stop() : start()
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Breathe")
        }
        .onDisappear { stop() }
    }

    private func remainingSeconds() -> Int {
        let r = max(0, (1.0 - progress) * currentDuration)
        return Int(ceil(r))
    }

    private func haptic() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    private func start() {
        isRunning = true
        runPhase(.inhale, duration: inhaleS)
    }

    private func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        progress = 0
        phase = .inhale
        currentDuration = inhaleS
    }

    private func runPhase(_ newPhase: BreathPhase, duration: Double) {
        phase = newPhase
        currentDuration = duration
        progress = 0
        haptic()

        timer?.invalidate()
        let startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            let elapsed = Date().timeIntervalSince(startTime)
            let p = min(1.0, elapsed / duration)
            withAnimation(.easeInOut(duration: 0.02)) {
                progress = p
            }

            if p >= 1.0 {
                timer?.invalidate()
                timer = nil
                nextPhase()
            }
        }
    }

    private func nextPhase() {
        guard isRunning else { return }
        switch phase {
        case .inhale: runPhase(.hold, duration: holdS)
        case .hold: runPhase(.exhale, duration: exhaleS)
        case .exhale: runPhase(.inhale, duration: inhaleS)
        }
    }
}

