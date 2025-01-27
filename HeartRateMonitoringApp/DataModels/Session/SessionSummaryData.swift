//
//  SessionSummaryData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 14/04/2024.
//

import Foundation

struct SessionSummaryData: Hashable {
    let sensor: DeviceRepresentable
    let username: String
    let session: SessionSimplified
    let measurements: [Int]
    var hrv: Int
    let sessionTime: Int
}
