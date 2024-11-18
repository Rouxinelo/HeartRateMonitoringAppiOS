//
//  SSEData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/11/2024.
//

struct SSEData: Codable {
    let sessionId: String
    let username: String
    let timeStamp: String
    let event: String
    let value: String
}

struct SSEDataEvents {
    static let enterSession = "ENTER_SESSION"
    static let leaveSession = "LEAVE_SESSION"
    static let heartRate = "HEARTRATE"
}
