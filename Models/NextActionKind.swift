//
//  NextActionKind.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import Foundation

enum NextActionKind: String, Codable {
    case breathe
    case logMood
    case logSleep
    case logNutrition
    case quickWalk
    case planWorkout
    case hydrateReset
}

struct NextBestAction {
    let kind: NextActionKind
    let title: String
    let subtitle: String
    let educational: String
    let systemImage: String
    let targetTab: AppTab
}
