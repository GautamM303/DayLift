//
//  StorageService.swift
//  DayLift
//

import Foundation

final class StorageService {
    static let shared = StorageService()
    private init() {}

    func saveCodable<T: Codable>(_ value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Storage save error for \(key): \(error)")
        }
    }

    func loadCodable<T: Codable>(_ type: T.Type, key: String, default defaultValue: T) -> T {
        guard let data = UserDefaults.standard.data(forKey: key) else { return defaultValue }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Storage load error for \(key): \(error)")
            return defaultValue
        }
    }
}

//  Created by Gautam Manerikar on 2026-01-10.
//

