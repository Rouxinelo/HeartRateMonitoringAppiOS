//
//  TeacherSessionSummaryUserData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/11/2024.
//

import Foundation

struct TeacherSessionSummaryUserData: Hashable {
    let user: User
    let measurements: [Int]
}
