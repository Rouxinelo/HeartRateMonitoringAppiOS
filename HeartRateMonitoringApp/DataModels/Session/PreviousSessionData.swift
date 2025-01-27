//
//  PreviousSessionData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import Foundation

struct PreviousSessionData: Hashable, Decodable {
    var session: Session
    var count: Int
    var average: Int
    var maximum: Int
    var minimum: Int
    var hrv: Int
}
