//
//  WorkoutViewModel.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import Foundation

@MainActor
final class WorkoutViewModel: ObservableObject {
    @Published private(set) var templates: [WorkoutTemplate] = []
    @Published private(set) var sessions: [WorkoutSession] = []

    private let storage = StorageService.shared

    init() {
        load()
    }

    private func load() {
        templates = storage.loadCodable([WorkoutTemplate].self,
                                       key: Constants.StorageKeys.workoutTemplates,
                                       default: [])
        sessions = storage.loadCodable([WorkoutSession].self,
                                       key: Constants.StorageKeys.workoutSessions,
                                       default: [])
        templates.sort { $0.createdAt > $1.createdAt }
        sessions.sort { $0.startedAt > $1.startedAt }
    }

    private func save() {
        storage.saveCodable(templates, key: Constants.StorageKeys.workoutTemplates)
        storage.saveCodable(sessions, key: Constants.StorageKeys.workoutSessions)
    }

    // MARK: - Templates
    func addTemplate(name: String) {
        let t = WorkoutTemplate(name: name, exercises: [])
        templates.insert(t, at: 0)
        save()
    }

    func updateTemplate(_ template: WorkoutTemplate) {
        guard let idx = templates.firstIndex(where: { $0.id == template.id }) else { return }
        templates[idx] = template
        save()
    }

    func deleteTemplate(_ template: WorkoutTemplate) {
        templates.removeAll { $0.id == template.id }
        save()
    }

    // MARK: - Sessions
    func startSession(for template: WorkoutTemplate) -> WorkoutSession {
        let s = WorkoutSession(
            templateId: template.id,
            templateName: template.name,
            startedAt: Date(),
            endedAt: nil,
            notes: "",
            exercises: template.exercises.map { ExerciseLog(name: $0.name, sets: []) }
        )
        sessions.insert(s, at: 0)
        save()
        return s
    }

    func endSession(_ sessionId: UUID) {
        guard let idx = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        if sessions[idx].endedAt == nil {
            sessions[idx].endedAt = Date()
            save()
        }
    }

    func addSet(sessionId: UUID, exerciseIndex: Int, reps: Int, weightKg: Double) {
        guard let sIdx = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        guard sessions[sIdx].exercises.indices.contains(exerciseIndex) else { return }

        sessions[sIdx].exercises[exerciseIndex].sets.append(
            WorkoutSet(reps: reps, weightKg: weightKg)
        )
        save()
    }

    func deleteSet(sessionId: UUID, exerciseIndex: Int, setId: UUID) {
        guard let sIdx = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        guard sessions[sIdx].exercises.indices.contains(exerciseIndex) else { return }

        sessions[sIdx].exercises[exerciseIndex].sets.removeAll { $0.id == setId }
        save()
    }

    func activeSession() -> WorkoutSession? {
        sessions.first(where: { $0.isActive })
    }

    // MARK: - History
    /// Deletes ALL workout history (sessions). Templates are kept.
    func clearHistory() {
        sessions.removeAll()
        save()
    }

    /// Deletes a single session (used by swipe-to-delete in history).
    func deleteSession(_ sessionId: UUID) {
        sessions.removeAll { $0.id == sessionId }
        save()
    }
    func workoutsCompletedLast7() -> Int {
        let cutoff = Date().daysAgo(6).startOfDay
        return sessions.filter { s in
            guard s.endedAt != nil else { return false }
            return s.startedAt.startOfDay >= cutoff
        }.count
    }

    func workoutStreak() -> Int {
        let completedDays = Set(
            sessions
                .filter { $0.endedAt != nil }
                .map { $0.startedAt.startOfDay }
        )

        var streak = 0
        var d = Date().startOfDay
        while completedDays.contains(d) {
            streak += 1
            d = d.daysAgo(1).startOfDay
        }
        return streak
    }

}
