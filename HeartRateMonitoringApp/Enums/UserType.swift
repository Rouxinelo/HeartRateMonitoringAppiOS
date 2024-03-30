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

public struct User: Hashable {
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var gender: String
    var age: Int
    var password: String
}
