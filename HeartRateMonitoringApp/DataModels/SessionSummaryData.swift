//
//  SessionSummaryData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 14/04/2024.
//

import Foundation

struct SessionSummaryData: Hashable {
    let sensor: MockDevice
    let user: UserSimplified
    let session: SessionSimplified
    let measurements: [Int]
    let sessionTime: Int
}
