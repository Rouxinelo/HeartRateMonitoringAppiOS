//
//  TeacherDataModels.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 10/08/2024.
//

import Foundation

struct CreateSessionData: Hashable {
    let teacherName: String
}

struct FutureSessionTeacherData: Hashable {
    let teacherName: String
}

struct PreviousSessionTeacherData: Hashable {
    let teacherName: String
}
