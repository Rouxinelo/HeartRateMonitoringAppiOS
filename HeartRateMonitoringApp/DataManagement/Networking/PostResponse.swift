//
//  PostResponse.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation

struct PostResponse: Codable {
    var statusCode: Int
    var message: String
}

struct ResponseMessages {
    static let registerSuccessfullMessage = "REGISTER_OK"
    static let registerFailedUsername = "REGISTER_FAILED_USERNAME_USED"
    static let registerFailedEmail = "REGISTER_FAILED_EMAIL_USED"
}
