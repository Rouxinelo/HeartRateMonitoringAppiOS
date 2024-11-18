//
//  NetworkManager.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 05/05/2024.
//

import Foundation
import Combine

enum NetworkManageResponse {
    case loadUserData(User? = nil)
    case loadTeacherData(Teacher? = nil)
    case loadCalendarSessions([Session]? = nil)
    case registerUserResult(RegisterUserResult)
    case didLoadSignedSessions([Session]? = nil)
    case didLoadPreviousSessions([Session]? = nil)
    case didLoadJoinableSessions([Session]? = nil)
    case didLoadPreviousSession(PreviousSessionData)
    case didSignInSession
    case didSignOutSession
    case didFailSign
    case didLogin
    case didSendRecoveryEmail
    case didNotSendRecoveryEmail
    case didChangePassword
    case didFailChangePassword
    case sessionOperationSuccessful
    case sessionOperationFailed
    case createSessionSuccessful
    case createSessionFailed
    case didLoadTeacherSessions([Session]? = nil)
    case didCancelSession
    case didFailCancelSession
    case didStartSession
    case urlUnavailable
    case failedRequest
}

enum RegisterUserResult {
    case usernameAlreadyRegistered
    case emailAlreadyRegistered
    case registerSuccessful
}

class NetworkManager {
    let decoder = JSONDataDecoder()
    let encoder = JSONDataEncoder()
    var statePublisher = PassthroughSubject<NetworkManageResponse, Never>()
    var subscriptions = Set<AnyCancellable>()

    func performRequest(apiPath: API) {
        switch apiPath {
        case .getUserData, .getAllSessions, .getUserSessions:
            performGETRequest(for: apiPath)
        case .register(let user):
            guard let data = encoder.encodeToJSON(user) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .signInSession(let username, let sessionId),
                .signOutSession(let username, let sessionId),
                .getSessionSummary(let username, let sessionId):
            guard let data = encoder.encodeToJSON(SessionSign(username: username, sessionId: sessionId)) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .login(let user):
            guard let data = encoder.encodeToJSON(user) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .loginTeacher(let teacher):
            guard let data = encoder.encodeToJSON(teacher) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .sendHeartRateData(let heartRateData):
            guard let data = encoder.encodeToJSON(heartRateData) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .sendSessionSummary(let postSessionData):
            guard let data = encoder.encodeToJSON(postSessionData) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .enterSession(let username, let sessionId), .leaveSession(let username, let sessionId):
            guard let data = encoder.encodeToJSON(SessionOperation(username: username, sessionId: sessionId)) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .changePassword(let data):
            guard let data = encoder.encodeToJSON(data) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .sendRecoveryEmail(let data):
            guard let data = encoder.encodeToJSON(data) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .createSession(let data):
            guard let data = encoder.encodeToJSON(data) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .getTeacherSessions(let teacher, let sessionType):
            guard let data = encoder.encodeToJSON(TeacherSessionData(name: teacher, type: sessionType.rawValue)) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .cancelSession(let teacher, let sessionId):
            guard let data = encoder.encodeToJSON(SessionCancelData(name: teacher, sessionId: sessionId)) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .startSession(let sessionData):
            guard let data = encoder.encodeToJSON(sessionData) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        default:
            return
        }
    }
    
    func stopConnection() {
        subscriptions.removeAll()
    }
    
    private func performPOSTRequest(for apiPath: API, with data: Data) {
        guard let url = URL(string: apiPath.path), let request = getRequest(for: apiPath, with: data, with: url) else {
            statePublisher.send(.urlUnavailable)
            return
        }
        URLSession.shared.dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(_):
                    statePublisher.send(.failedRequest)
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                decodeData(data: response.data, apiPath: apiPath)
            }
            ).store(in: &subscriptions)
    }
    
    private func performGETRequest(for apiPath: API) {
        guard let url = URL(string: apiPath.path) else {
            statePublisher.send(.urlUnavailable)
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(_):
                    statePublisher.send(.failedRequest)
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                decodeData(data: response.data, apiPath: apiPath)
            }
            ).store(in: &subscriptions)
    }
    
    private func decodeData(data: Data, apiPath: API) {
        switch apiPath {
        case .login:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleLoginUserResponse(response: response)
        case .register:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleRegisterUserResponse(response: response)
        case .getUserData:
            statePublisher.send(.loadUserData(decoder.decodeUserData(data: data)))
        case .getAllSessions:
            statePublisher.send(.loadCalendarSessions(decoder.decodeSessions(data: data)))
        case .getUserSessions(_, let type):
            guard let sessions = decoder.decodeSessions(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleGetUserSessions(type: type, sessions: sessions)
        case .signInSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleSignInSessionResponse(response: response)
        case .signOutSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleSignOutSessionResponse(response: response)
        case .sendHeartRateData:
            return
        case .getSessionSummary:
            guard let response = decoder.decodePreviousSession(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            statePublisher.send(.didLoadPreviousSession(response))
        case .enterSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleSessionOperation(response: response)
        case .leaveSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleSessionOperation(response: response)
        case .sendRecoveryEmail, .changePassword:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handlePasswordRecoveryResponse(response: response)
        case .createSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleCreateSessionResponse(response: response)
        case .loginTeacher:
            guard let response = decoder.decodeTeacherData(data: data) else {
                statePublisher.send(.loadTeacherData(nil))
                return
            }
            handleTeacherDataResponse(teacher: response)
        case .getTeacherSessions:
            guard let response = decoder.decodeSessions(data: data) else {
                statePublisher.send(.loadTeacherData(nil))
                return
            }
            handleTeacherSessions(sessions: response)
        case .cancelSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.loadTeacherData(nil))
                return
            }
            handleCancelSessionResponse(response: response)
        case .startSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleStartSessionResponse(response: response)
        default:
            return
        }
    }
    
    private func getRequest(for apiPath: API, with params: Data, with url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = apiPath.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = params
        return request
    }
}

// MARK: - Handling POST Request Responses

private extension NetworkManager {
    func handleTeacherDataResponse(teacher: Teacher) {
        statePublisher.send(.loadTeacherData(teacher))
    }
    
    func handleSessionOperation(response: PostResponse) {
        switch response.message {
        case ResponseMessages.enterSessionSuccessful, ResponseMessages.leaveSessionSuccessful:
            statePublisher.send(.sessionOperationSuccessful)
        default:
            statePublisher.send(.sessionOperationFailed)
        }
    }
    
    func handleGetUserSessions(type: SessionType, sessions: [Session]) {
        switch type {
        case .joinable:
            statePublisher.send(.didLoadJoinableSessions(sessions))
        case .previous:
            statePublisher.send(.didLoadPreviousSessions(sessions))
        case .signed:
            statePublisher.send(.didLoadSignedSessions(sessions))
        }
    }
    
    func handleRegisterUserResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.registerFailedEmail:
            statePublisher.send(.registerUserResult(.emailAlreadyRegistered))
        case ResponseMessages.registerFailedUsername:
            statePublisher.send(.registerUserResult(.usernameAlreadyRegistered))
        case ResponseMessages.registerSuccessfullMessage:
            statePublisher.send(.registerUserResult(.registerSuccessful))
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handleSignInSessionResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.signInSessionSuccessful:
            statePublisher.send(.didSignInSession)
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handleSignOutSessionResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.signOutSessionSuccessful:
            statePublisher.send(.didSignOutSession)
        case ResponseMessages.signOutSessionFailed:
            statePublisher.send(.didFailSign)
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handleLoginUserResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.loginSuccessful:
            statePublisher.send(.didLogin)
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handlePasswordRecoveryResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.emailSent:
            statePublisher.send(.didSendRecoveryEmail)
        case ResponseMessages.emailFailed:
            statePublisher.send(.didNotSendRecoveryEmail)
        case ResponseMessages.changePassSuccessful:
            statePublisher.send(.didChangePassword)
        case ResponseMessages.changePassFailed:
            statePublisher.send(.didFailChangePassword)
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handleCreateSessionResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.createSessionSuccessful:
            statePublisher.send(.createSessionSuccessful)
        case ResponseMessages.createSessionFail:
            statePublisher.send(.createSessionFailed)
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handleCancelSessionResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.cancelSessionFail:
            statePublisher.send(.didFailCancelSession)
        case ResponseMessages.cancelSessionSuccessful:
            statePublisher.send(.didCancelSession)
        default:
            statePublisher.send(.failedRequest)
        }
    }
    
    func handleTeacherSessions(sessions: [Session]) {
        statePublisher.send(.didLoadTeacherSessions(sessions))
    }
    
    func handleStartSessionResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.startSessionSuccessful:
            statePublisher.send(.didStartSession)
        default:
            statePublisher.send(.failedRequest)
        }
    }
}
