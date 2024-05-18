//
//  PreviousSessionData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import Foundation

struct PreviousSessionData: Hashable {
    var session: Session
    var username: String
    var measurements: [Int]
}
