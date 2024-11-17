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
