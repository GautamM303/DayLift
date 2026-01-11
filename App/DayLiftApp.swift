//
//  DayLiftApp.swift
//  DayLift
//
import SwiftUI
import UIKit

@main
struct DayLiftApp: App {

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // tab bar background (optional)
        appearance.backgroundColor = UIColor.systemBackground

        // selected icon/text color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemGreen
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemGreen
        ]

        // unselected icon/text color
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray2
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray2
        ]

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}



//  Created by Gautam Manerikar on 2026-01-10.
//
