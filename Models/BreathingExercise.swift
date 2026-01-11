//
//  BreathingExercise.swift
//  DayLift
//
import Foundation

struct BreathingExercise: Identifiable {
    var id = UUID()
    var name: String
    var inhaleSeconds: Int
    var holdSeconds: Int
    var exhaleSeconds: Int
    var cycles: Int
    
    static let exercises: [BreathingExercise] = [
        BreathingExercise(name: "4-7-8 Breathing", inhaleSeconds: 4, holdSeconds: 7, exhaleSeconds: 8, cycles: 4),
        BreathingExercise(name: "Box Breathing", inhaleSeconds: 4, holdSeconds: 4, exhaleSeconds: 4, cycles: 4),
        BreathingExercise(name: "Calm Breathing", inhaleSeconds: 4, holdSeconds: 0, exhaleSeconds: 6, cycles: 5)
    ]
    
    var totalDuration: Int {
        return (inhaleSeconds + holdSeconds + exhaleSeconds) * cycles
    }
}
//  Created by Gautam Manerikar on 2026-01-10.
//

