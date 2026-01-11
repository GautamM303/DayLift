//
//  Theme.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//

import SwiftUI
import UIKit

// MARK: - DayLift Theme (dark-mode aware, non-reactive global look)
enum Theme {

    // Dynamic backgrounds that follow Light/Dark mode
    static let background = Color(uiColor: UIColor { tc in
        tc.userInterfaceStyle == .dark
        ? UIColor(red: 0.06, green: 0.07, blue: 0.09, alpha: 1.0)   // near-black
        : UIColor(red: 0.96, green: 0.98, blue: 0.99, alpha: 1.0)   // soft light
    })

    static let surface = Color(uiColor: UIColor { tc in
        tc.userInterfaceStyle == .dark
        ? UIColor(red: 0.11, green: 0.12, blue: 0.15, alpha: 1.0)   // card background
        : UIColor.white
    })

    static let surfaceAlt = Color(uiColor: UIColor { tc in
        tc.userInterfaceStyle == .dark
        ? UIColor(red: 0.15, green: 0.16, blue: 0.20, alpha: 1.0)   // slightly lighter than surface
        : UIColor(red: 0.93, green: 0.96, blue: 1.00, alpha: 1.0)   // subtle blue tint
    })

    static let textPrimary = Color(uiColor: UIColor { tc in
        tc.userInterfaceStyle == .dark ? .white : UIColor(red: 0.12, green: 0.16, blue: 0.20, alpha: 1.0)
    })

    static let textSecondary = Color(uiColor: UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(white: 0.75, alpha: 1.0) : UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0)
    })

    // Brand colors (kept stable)
    static let blue = Color(hex: "#4A90E2")
    static let green = Color(hex: "#6BCF9E")
    static let yellow = Color(hex: "#FFD166")

    // Low mood accent (muted, not alarming)
    static let low = Color(hex: "#6B7A99")

    // Accent (still available, but you are no longer forced to use it globally)
    static func accent(for mood: Mood?) -> Color {
        guard let mood else { return blue }
        if mood.isNegative { return low }
        return green
    }

    // Cards that look consistent across screens
    static func card<Content: View>(_ content: Content) -> some View {
        content
            .padding()
            .background(Theme.surface)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.20), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Hex Color helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
