//
//  SessionUserData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import Foundation
import MovesenseApi

struct SessionData: Hashable {
    let session: SessionSimplified
    let username: String
    let device: DeviceRepresentable
}

struct SessionSimplified: Hashable {
    let id: String
    let name: String
    let teacher: String
}
