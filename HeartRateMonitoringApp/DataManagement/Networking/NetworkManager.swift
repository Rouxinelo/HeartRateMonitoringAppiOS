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
    case urlUnavailable
    case failedRequest
}

enum RegisterUserResult {
    case usernameAlreadyRegistered
    case emailAlreadyRegistered
    case registerSuccessful
    case urlUnavailable
}

class NetworkManager {
    let decoder = JSONDataDecoder()
    var statePublisher = PassthroughSubject<NetworkManageResponse, Never>()
    var subscriptions = Set<AnyCancellable>()

    func performGetRequest(apiPath: API) {
        switch apiPath {
        case .getUserData:
            performGETRequest(for: apiPath)
        case .getAllSessions:
            performGETRequest(for: apiPath)
        case .getUserSessions:
            performGETRequest(for: apiPath)
        default:
            print("ERROR. NOT A VALID GET REQUEST")
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
                print(response)
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
            return
        case .getUserData:
            statePublisher.send(.loadUserData(decoder.decodeUserData(data: data)))
        case .getAllSessions:
            statePublisher.send(.loadCalendarSessions(decoder.decodeSessions(data: data)))
        case .getUserSessions(let string):
            return
        case .signInSession(let string, let string2):
            return
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
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            return request
        } catch {
            return nil
        }
    }
}
