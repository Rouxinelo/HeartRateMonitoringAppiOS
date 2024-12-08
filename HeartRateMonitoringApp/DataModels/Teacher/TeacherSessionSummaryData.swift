//
//  TeacherSessionSummaryData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/11/2024.
//

import Foundation

struct TeacherSessionSummaryData: Hashable {
    let sessionName: String
    let sessionTime: String
    let sessionUserData: [TeacherSessionUserData]
}
