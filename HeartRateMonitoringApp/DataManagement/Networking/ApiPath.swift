//
//  ApiPath.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 05/05/2024.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
}

enum API {
    case login(UserLogin)
    case register(RegisterUser)
    case getUserData(String)
    case getAllSessions(String)
    case getUserSessions(String, UserSessionType)
    case signInSession(String, String)
    case signOutSession(String, String)
    case sendHeartRateData(HeartRateData)
    case sendSessionSummary(PostSessionData)
    case getSessionSummary(String, String)
    case enterSession(String, String)
    case leaveSession(String, String)
}

extension API: TargetType {
    var baseURL: String {
        "http://192.168.1.68:8000/"
    }
    
    var path: String {
        switch self {
        case .login:
            return baseURL + "login-user"
        case .register:
            return baseURL + "register-user"
        case .getUserData(let username):
            return baseURL + "get-user/\(username)"
        case .getAllSessions(let username):
            return baseURL + "get-sessions/\(username)"
        case .getUserSessions(let username, let type):
            return baseURL + "get-user-sessions/\(username)/\(type)/"
        case .signInSession:
            return baseURL + "session-sign-in/"
        case .signOutSession:
            return baseURL + "session-sign-out/"
        case .sendHeartRateData:
            return baseURL + "heartbeat-info/"
        case .sendSessionSummary:
            return baseURL + "session-summary/"
        case .getSessionSummary:
            return baseURL + "get-session-summary/"
        case .enterSession:
            return baseURL + "enter-session/"
        case .leaveSession:
            return baseURL + "leave-session/"
        }
    }
    
    var method: String {
        switch self {
        case .login:
            return "POST"
        case .register:
            return "POST"
        case .getUserData:
            return "GET"
        case .getAllSessions:
            return "GET"
        case .getUserSessions:
            return "GET"
        case .signInSession:
            return "POST"
        case .signOutSession:
            return "POST"
        case .sendHeartRateData:
            return "POST"
        case .sendSessionSummary:
            return "POST"
        case .getSessionSummary:
            return "POST"
        case .enterSession:
            return "POST"
        case .leaveSession:
            return "POST"
        }
    }
}
