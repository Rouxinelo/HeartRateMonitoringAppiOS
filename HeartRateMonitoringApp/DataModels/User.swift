//
//  User.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import Foundation

public struct User: Hashable {
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var gender: String
    var age: Int
    var password: String
}
