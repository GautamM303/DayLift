//
//  ProfileViewModel.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-10.
//


import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile = .default {
        didSet { save() }
    }

    private let storage = StorageService.shared

    init() {
        load()
    }

    private func load() {
        profile = storage.loadCodable(UserProfile.self,
                                      key: Constants.StorageKeys.userProfile,
                                      default: .default)
    }

    private func save() {
        storage.saveCodable(profile, key: Constants.StorageKeys.userProfile)
    }

    /// Mifflin–St Jeor BMR estimate (kcal/day)
    func bmr() -> Double {
        let w = profile.weightKg
        let h = profile.heightCm
        let a = Double(profile.age)

        switch profile.sex {
        case .male:
            return 10*w + 6.25*h - 5*a + 5
        case .female:
            return 10*w + 6.25*h - 5*a - 161
        case .unspecified:
            // neutral middle option for demo: average of male/female constants
            return 10*w + 6.25*h - 5*a - 78
        }
    }

    func maintenanceCalories() -> Int {
        Int((bmr() * profile.activity.multiplier).rounded())
    }

    func recommendedCalories() -> Int {
        max(1200, maintenanceCalories() + profile.goal.adjustment)
    }

    func bmi() -> Double {
        let hM = profile.heightCm / 100.0
        guard hM > 0 else { return 0 }
        return profile.weightKg / (hM * hM)
    }
}
