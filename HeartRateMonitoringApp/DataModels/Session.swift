//
//  Session.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import Foundation

struct Session: Hashable, Identifiable {
    let id: String
    let name: String
    let date: String
    let hour: String
    let teacher: String
    let totalSpots: Int
    let filledSpots: Int
    var description: String?
}
