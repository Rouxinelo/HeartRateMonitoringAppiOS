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
    case logout(UserLogout)
    case loginTeacher(Teacher)
    case register(RegisterUser)
    case getUserData(String)
    case getAllSessions(String)
    case getUserSessions(String, SessionType)
    case signInSession(String, String)
    case signOutSession(String, String)
    case sendHeartRateData(HeartRateData)
    case sendHrvData(HRVData)
    case sendSessionSummary(PostSessionData)
    case getSessionSummary(String, String)
    case enterSession(String, String)
    case leaveSession(String, String)
    case sendRecoveryEmail(RecoveryEmailData)
    case changePassword(PasswordChangeData)
    case createSession(SessionCreationData)
    case getTeacherSessions(String, SessionType)
    case cancelSession(String, String)
    case startSession(SessionStartData)
    case closeSession(SessionCloseData)
    case session(String)
}

extension API: TargetType {
    var baseURL: String {
        "http://192.168.1.97:8000/"
    }
    
    var path: String {
        switch self {
        case .login:
            return baseURL + "login-user"
        case .logout:
            return baseURL + "logout-user"
        case .loginTeacher:
            return baseURL + "login-teacher"
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
        case .sendHrvData:
            return baseURL + "hrv/"
        case .sendSessionSummary:
            return baseURL + "session-summary/"
        case .getSessionSummary:
            return baseURL + "get-session-summary/"
        case .enterSession:
            return baseURL + "enter-session/"
        case .leaveSession:
            return baseURL + "leave-session/"
        case .sendRecoveryEmail:
            return baseURL + "send-recovery-email/"
        case .changePassword:
            return baseURL + "change-password/"
        case .createSession:
            return baseURL + "create-session/"
        case .getTeacherSessions:
            return baseURL + "get-teacher-sessions/"
        case .cancelSession:
            return baseURL + "cancel-session/"
        case .startSession:
            return baseURL + "start-session/"
        case .session(let sessionId):
            return baseURL + "session/\(sessionId)/"
        case .closeSession:
            return baseURL + "close-session/"
        }
    }
    
    var method: String {
        switch self {
        case .login:
            return "POST"
        case .logout:
            return "POST"
        case .loginTeacher:
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
        case .sendHrvData:
            return "POST"
        case .sendSessionSummary:
            return "POST"
        case .getSessionSummary:
            return "POST"
        case .enterSession:
            return "POST"
        case .leaveSession:
            return "POST"
        case .sendRecoveryEmail:
            return "POST"
        case .changePassword:
            return "POST"
        case .createSession:
            return "POST"
        case .getTeacherSessions:
            return "POST"
        case .cancelSession:
            return "POST"
        case .startSession:
            return "POST"
        case .session:
            return "GET"
        case .closeSession:
            return "POST"
        }
    }
}
