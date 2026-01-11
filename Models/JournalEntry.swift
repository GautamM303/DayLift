//
//  JournalEntry.swift
//  DayLift
//
//  Created by Gautam Manerikar on 2026-01-11.
//


import Foundation

struct JournalEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date            // startOfDay
    var text: String
    var tags: [String]

    init(id: UUID = UUID(), date: Date = Date(), text: String, tags: [String] = []) {
        self.id = id
        self.date = date.startOfDay
        self.text = text
        self.tags = tags
    }
}
