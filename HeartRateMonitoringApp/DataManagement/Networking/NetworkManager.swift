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
    case loadCalendarSessions([Session]? = nil)
    case registerUserResult(RegisterUserResult)
    case didLoadSignedSessions([Session]? = nil)
    case didLoadPreviousSessions([Session]? = nil)
    case didLoadJoinableSessions([Session]? = nil)
    case didSignInSession
    case didSignOutSession
    case didFailSign
    case didLogin
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
        case .signInSession(let username, let sessionId):
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
        default:
            print("ERROR. NOT A VALID REQUEST")
            break
        }
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
            switch type {
            case .joinable:
                statePublisher.send(.didLoadJoinableSessions(sessions))
            case .previous:
                statePublisher.send(.didLoadPreviousSessions(sessions))
            case .signed:
                statePublisher.send(.didLoadSignedSessions(sessions))
            }
        case .signInSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleSignInSessionResponse(response: response)
        case .signOutSession:
            return
        case .sendHeartRateData:
            return
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
    
    func handleLoginUserResponse(response: PostResponse) {
        switch response.message {
        case ResponseMessages.loginSuccessful:
            statePublisher.send(.didLogin)
        default:
            statePublisher.send(.failedRequest)
        }
    }
}
