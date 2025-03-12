//
//  PostSessionData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/05/2024.
//

import Foundation

struct PostSessionData: Codable {
    let username: String
    let sessionId: String
    let measurements: [Int]
    let hrv: Int
}
