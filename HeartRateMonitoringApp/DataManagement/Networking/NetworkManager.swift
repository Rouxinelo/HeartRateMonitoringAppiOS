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
}

class NetworkManager {
    let decoder = JSONDataDecoder()
    var statePublisher = PassthroughSubject<NetworkManageResponse, Never>()
    var subscriptions = Set<AnyCancellable>()

    func performGetRequest(apiPath: API) {
        switch apiPath {
        case .login:
            return
        case .register:
            return
        case .getUserData:
            performGETRequest(for: apiPath)
        case .getAllSessions:
            performGETRequest(for: apiPath)
        case .getUserSessions:
            performGETRequest(for: apiPath)
        case .signInSession:
            return
        case .signOutSession:
            return
        case .sendHeartRateData:
            return
        case .sendSessionSummary:
            return
        }
    }
    
    private func performGETRequest(for apiPath: API) {
        guard let url = URL(string: apiPath.path) else {
            statePublisher.send(.loadUserData(nil))
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let failure):
                    statePublisher.send(.loadUserData())
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                decodeData(data: response.data, apiPath: apiPath)
            }
            ).store(in: &subscriptions)
    }
    
    func decodeData(data: Data, apiPath: API) {
        switch apiPath {
        case .login(let user):
            return
        case .register(let user):
            return
        case .getUserData:
            statePublisher.send(.loadUserData(decoder.decodeUserData(data: data)))
        case .getAllSessions(let string):
            return
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
}
