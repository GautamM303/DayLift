//
//  Mood.swift
//  DayLift
//

import Foundation

enum Mood: Int, CaseIterable, Codable, Identifiable {
    case veryLow = 0
    case low = 1
    case neutral = 2
    case good = 3
    case great = 4

    var id: Int { rawValue }

    var emoji: String {
        switch self {
        case .veryLow: return "😞"
        case .low: return "😔"
        case .neutral: return "😐"
        case .good: return "🙂"
        case .great: return "😄"
        }
    }

    var label: String {
        switch self {
        case .veryLow: return "Very low"
        case .low: return "Low"
        case .neutral: return "Neutral"
        case .good: return "Good"
        case .great: return "Great"
        }
    }

    var isNegative: Bool {
        self == .veryLow || self == .low
    }
}
//  Created by Gautam Manerikar on 2026-01-10.
//

