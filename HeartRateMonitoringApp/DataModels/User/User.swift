//
//  User.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import Foundation

public struct User: Hashable, Codable {
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let age: Int
}
