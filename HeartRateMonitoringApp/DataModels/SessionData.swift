//
//  SessionUserData.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import Foundation

struct SessionData: Hashable {
    let session: SessionSimplified
    let user: UserSimplified
    var device: MockDevice
}

struct SessionSimplified: Hashable {
    let id: String
    let name: String
    let teacher: String
}

struct UserSimplified: Hashable {
    let username: String
}

