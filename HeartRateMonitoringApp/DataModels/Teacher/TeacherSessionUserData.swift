//
//  TeacherSessionUserData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/11/2024.
//

struct TeacherSessionUserData: Hashable {
    let username: String
    let name: String
    var measurements: [Int]
    var isActive: Bool = true
}
