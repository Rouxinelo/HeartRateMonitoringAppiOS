//
//  StartSessionData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/10/2024.
//

import Foundation

struct StartSessionData: Codable {
    let sessionId: String
    let zoomId: String
    let zoomPassword: String
}
