//
//  RecoveryEmailData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 06/08/2024.
//

import Foundation

struct RecoveryEmailData: Codable {
    let username: String
    let code: Int
    let languageCode: String
}
