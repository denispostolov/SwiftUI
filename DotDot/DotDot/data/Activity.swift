//
//  Activity.swift
//  DotDot
//
//  Created by Denis Postolov on 14/05/25.
//

import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case personal = "Personal"
    case wellness = "Wellness"
    case sport = "Sport"
    case schedule = "Schedule"
    case work = "Work"
}

struct Activity: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let type: ActivityType
    var description: String
    var dayStreak: Int
    
    init(id: UUID = UUID(), name: String, type: ActivityType, description: String, dayStreak: Int = 1) {
        self.name = name
        self.type = type
        self.description = description
        self.dayStreak = dayStreak
    }
}
