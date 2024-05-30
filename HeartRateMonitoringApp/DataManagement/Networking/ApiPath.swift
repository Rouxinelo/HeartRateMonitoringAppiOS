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
    var params: [String : AnyObject]? { get }
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
