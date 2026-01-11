//
//  ResetTimerView.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import SwiftUI

struct ResetTimerView: View {
    @Environment(\.dismiss) private var dismiss
    let routine: ResetRoutine

    @State private var stepIndex: Int = 0
    @State private var remaining: Int = 0
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil

    var body: some View {
        let step = routine.steps[stepIndex]

        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text(routine.title)
                    .font(.title2).bold()

                Text("\(routine.category.rawValue)")
                    .foregroundStyle(.secondary)

                Divider()

                Text(step.title)
                    .font(.title3).bold()

                Text(step.detail)
                    .foregroundStyle(.secondary)

                Text("\(remaining)s")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .padding(.top, 8)

                ProgressView(value: progressForCurrentStep())
                    .padding(.top, 4)

                HStack(spacing: 10) {
                    Button(isRunning ? "Pause" : "Start") {
                        isRunning ? pause() : start()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Next") {
                        nextStep()
                    }
                    .buttonStyle(.bordered)
                    .disabled(stepIndex >= routine.steps.count - 1)

                    Button("Restart") {
                        restart()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .navigationTitle("Reset")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        stopTimer()
                        dismiss()
                    }
                }
            }
            .onAppear {
                remaining = routine.steps.first?.seconds ?? 0
            }
            .onDisappear {
                stopTimer()
            }
        }
    }

    private func progressForCurrentStep() -> Double {
        let total = Double(routine.steps[stepIndex].seconds)
        guard total > 0 else { return 0 }
        return 1.0 - (Double(remaining) / total)
    }

    private func start() {
        guard !isRunning else { return }
        isRunning = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remaining > 0 {
                remaining -= 1
            } else {
                nextStep()
            }
        }
    }

    private func pause() {
        isRunning = false
        stopTimer()
    }

    private func restart() {
        stepIndex = 0
        remaining = routine.steps.first?.seconds ?? 0
        isRunning = false
        stopTimer()
    }

    private func nextStep() {
        if stepIndex < routine.steps.count - 1 {
            stepIndex += 1
            remaining = routine.steps[stepIndex].seconds
            if isRunning { start() }
        } else {
            // finished
            isRunning = false
            stopTimer()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
