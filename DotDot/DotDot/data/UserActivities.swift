//
//  UserActivities.swift
//  DotDot
//
//  Created by Denis Postolov on 14/05/25.
//

import Foundation

@Observable
class UserActivities {
    var activities: [Activity]
    
    init(activities: [Activity]) {
        self.activities = activities
    }
}
