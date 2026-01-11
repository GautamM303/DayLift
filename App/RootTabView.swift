//
//  RootTabView.swift
//  DayLift
//
import SwiftUI

enum AppTab: Hashable {
    case checkIn
    case breathe
    case nutrition
    case workouts
    case journal
    case insights
    case settings
}

struct RootTabView: View {
    @State private var tab: AppTab = .checkIn

    @StateObject private var moodVM = MoodViewModel()
    @StateObject private var nutritionVM = NutritionViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var workoutVM = WorkoutViewModel()
    @StateObject private var journalVM = JournalViewModel()

    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var showProfileSetup = false
    @State private var showMoodPrompt = false

    var body: some View {
        TabView(selection: $tab) {
            CheckInView(selectedTab: $tab)
                .environmentObject(moodVM)
                .environmentObject(profileVM)
                .tabItem { Label("Check-In", systemImage: "face.smiling") }
                .tag(AppTab.checkIn)

            BreatheView()
                .tabItem { Label("Breathe", systemImage: "wind") }
                .tag(AppTab.breathe)

            NutritionView()
                .environmentObject(nutritionVM)
                .environmentObject(profileVM)
                .tabItem { Label("Nutrition", systemImage: "fork.knife") }
                .tag(AppTab.nutrition)

            WorkoutsView()
                .environmentObject(workoutVM)
                .tabItem { Label("Workouts", systemImage: "dumbbell") }
                .tag(AppTab.workouts)

            JournalView()
                .environmentObject(journalVM)
                .tabItem { Label("Journal", systemImage: "book.closed") }
                .tag(AppTab.journal)

            // ✅ THIS is the important one: Insights MUST get these EnvironmentObjects
            InsightsView()
                .environmentObject(moodVM)
                .environmentObject(nutritionVM)
                .environmentObject(profileVM)
                .tabItem { Label("Insights", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(AppTab.insights)

            SettingsView()
                .environmentObject(profileVM)
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(AppTab.settings)
        }
        .onAppear {
            if !hasOnboarded {
                showProfileSetup = true
            } else if moodVM.moodForToday() == nil {
                showMoodPrompt = true
            }
        }
        .sheet(isPresented: $showProfileSetup, onDismiss: {
            hasOnboarded = true
            if moodVM.moodForToday() == nil {
                showMoodPrompt = true
            }
        }) {
            ProfileSetupSheet()
                .environmentObject(profileVM)
        }
        .sheet(isPresented: $showMoodPrompt) {
            MoodPromptSheet(
                onGoToBreathe: { tab = .breathe },
                onGoToJournal: { tab = .journal }
            )
            .environmentObject(moodVM)
        }
    }
}

//  Created by Gautam Manerikar on 2026-01-10.
//

