//
//  DeviceToken.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 12/01/2025.
//

import Foundation

final class DeviceToken {
    static let shared = DeviceToken()
    private init() {}

    var apiToken: String?
}

public func getApiToken() -> String {
    return DeviceToken.shared.apiToken ?? ""
}
