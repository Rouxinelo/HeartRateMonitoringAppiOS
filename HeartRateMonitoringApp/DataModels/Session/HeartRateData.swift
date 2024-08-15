//
//  HeartRateData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/05/2024.
//

import Foundation

struct HeartRateData: Codable {
    let username: String
    let sessionId: String
    let heartRate: Int
    let timeStamp: Int
}
