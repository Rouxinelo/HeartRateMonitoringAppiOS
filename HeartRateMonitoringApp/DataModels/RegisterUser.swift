//
//  RegisterUser.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation

struct RegisterUser: Codable {
    let username: String
    let password: String
    let email: String
    let firstName: String
    let lastName: String
    let birthDay: Int
    let birthMonth: Int
    let birthYear: Int
    let gender: String
}
