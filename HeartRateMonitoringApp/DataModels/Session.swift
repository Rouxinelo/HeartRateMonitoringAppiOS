//
//  Session.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import Foundation

struct Session: Hashable, Identifiable {
    var id: String
    var name: String
    var date: String
    var hour: String
    var teacher: String
    var totalSpots: Int
    var filledSpots: Int
    var description: String?
}
