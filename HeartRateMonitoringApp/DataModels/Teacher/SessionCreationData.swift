//
//  SessionCreationData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/08/2024.
//

import Foundation

struct SessionCreationData: Codable {
    let teacher: String
    let name: String
    let description: String
    let date: String
    let hour: String
    let totalSpots: Int
}
