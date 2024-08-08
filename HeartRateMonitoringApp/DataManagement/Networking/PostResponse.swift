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
    static let loginSuccessful = "LOGIN_OK"
    static let registerFailedUsername = "REGISTER_FAILED_USERNAME_USED"
    static let registerFailedEmail = "REGISTER_FAILED_EMAIL_USED"
    static let signInSessionSuccessful = "SIGN_IN_OK"
    static let signOutSessionSuccessful = "SIGN_OUT_OK"
    static let signOutSessionFailed = "SIGN_OUT_FAIL"
    static let enterSessionSuccessful = "ENTER_SESSION_OK"
    static let leaveSessionSuccessful = "LEAVE_SESSION_OK"
    static let emailSent = "EMAIL_SENT"
    static let emailFailed = "EMAIL_NOT_SENT"
    static let changePassSuccessful = "CHANGE_PASS_OK"
    static let changePassFailed = "CHANGE_PASS_FAIL"
    static let genericError = "ERROR"
}
