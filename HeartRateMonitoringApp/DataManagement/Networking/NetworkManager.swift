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
    case didSignInSession
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
            guard let data = encoder.encodeRegister(user: user) else {
                statePublisher.send(.failedRequest)
                return
            }
            performPOSTRequest(for: apiPath, with: data)
        case .signInSession(let username, let sessionId):
            guard let data = encoder.encodeSessionSignIn(sessionSignData: SessionSign(username: username, sessionId: sessionId)) else {
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
        case .login(let user):
            return
        case .register(let user):
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleRegisterUserResponse(response: response)
        case .getUserData:
            statePublisher.send(.loadUserData(decoder.decodeUserData(data: data)))
        case .getAllSessions:
            statePublisher.send(.loadCalendarSessions(decoder.decodeSessions(data: data)))
        case .getUserSessions(let string):
            return
        case .signInSession:
            guard let response = decoder.decodeResponse(data: data) else {
                statePublisher.send(.failedRequest)
                return
            }
            handleSignInSessionResponse(response: response)
        case .signOutSession(let string, let string2):
            return
        case .sendHeartRateData:
            return
        case .sendSessionSummary:
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
}
