//
//  ApiPath.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 05/05/2024.
//

import Foundation

let URLPath: String = "192.168.1.68:8000/"

protocol TargetType {
    var path: String { get }
    var method: String { get }
    var params: [String : AnyObject]? { get }
}

enum API {
    case login(User)
    case register(User)
    case getUserData(String)
    case getAllSessions(String)
    case getUserSessions(String)
    case signInSession(String, String)
    case signOutSession(String, String)
    case sendHeartRateData
    case sendSessionSummary
}

extension API: TargetType {
    var path: String {
        switch self {
        case .login:
            return "login-user"
        case .register:
            return "register-user"
        case .getUserData(let username):
            return "get-user/\(username)"
        // MIssing IMPL Backend
        case .getAllSessions(let username):
            return "get-available-sessions/\(username)"
        // MIssing IMPL Backend
        case .getUserSessions(let username):
            return "get-user-sessions/\(username)"
        // MIssing IMPL Backend
        case .signInSession:
            return "session-sign-out/"
        // MIssing IMPL Backend
        case .signOutSession:
            return "session-sign-in/"
        case .sendHeartRateData:
            return "heartbeat-info/"
        // Missing IMPL Backend
        case .sendSessionSummary:
            return "session-summary"
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
        }
    }
    
    var params: [String: AnyObject]? {
        switch self {
        case .login(let user):
            return ["username": user.username, "password": user.password] as [String: AnyObject]
        case .register(let user):
            return ["user": user] as [String: AnyObject]
        case .getUserData:
            return nil
        case .getAllSessions:
            return nil
        case .getUserSessions:
            return nil
        case .signInSession(let username, let sessionId):
            return ["username": username, "sessionId": sessionId] as [String: AnyObject]
        case .signOutSession(let username, let sessionId):
            return ["username": username, "sessionId": sessionId] as [String: AnyObject]
        case .sendHeartRateData:
            return nil
        case .sendSessionSummary:
            return nil
        }
    }
}
