//
//  UserType.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 19/03/2024.
//

import Foundation

public enum UserType: Hashable {
    case guest
    case login(User)
}
