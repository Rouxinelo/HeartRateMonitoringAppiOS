//
//  UserSessionsViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/05/2024.
//

import Foundation
import Combine

enum UserSessionPublisherCases {
    case didLoadJoinableSessions([Session]?)
    case didLoadSignedSessions([Session]?)
    case didLoadPreviousSessions([Session]?)
    case didLoadPreviousSession(PreviousSessionData?)
    case didFailSignOut
    case didSignOut
    case networkError
}

class UserSessionsViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<UserSessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func fetchSessions(for user: String, _ type: SessionType) {
        networkManager.performRequest(apiPath: .getUserSessions(user, type))
    }
    
    func signOutSession(for user: String, sessionId: String) {
        networkManager.performRequest(apiPath: .signOutSession(user, sessionId))
    }
    
    func fetchPreviousSession(for user: String, sessionId: String) {
        networkManager.performRequest(apiPath: .getSessionSummary(user, sessionId))
    }
}

private extension UserSessionsViewModel {
    func bind() {
        bindSessionsRecieved()
        bindSessionSignOut()
        bindPreviousSession()
    }
    
    func bindSessionsRecieved() {
        networkManager.statePublisher.sink { [weak self] recieveValue in
            guard let self = self else { return }
            switch recieveValue {
            case .didLoadJoinableSessions(let sessions):
                publisher.send(.didLoadJoinableSessions(sessions))
            case .didLoadSignedSessions(let sessions):
                publisher.send(.didLoadSignedSessions(sessions))
            case .didLoadPreviousSessions(let sessions):
                publisher.send(.didLoadPreviousSessions(sessions))
            case .failedRequest:
                publisher.send(.networkError)
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func bindSessionSignOut() {
        networkManager.statePublisher.sink { [weak self] recieveValue in
            guard let self = self else { return }
            switch recieveValue {
            case .didSignOutSession:
                publisher.send(.didSignOut)
            case .didFailSign:
                publisher.send(.didFailSignOut)
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func bindPreviousSession() {
        networkManager.statePublisher.sink { [weak self] recieveValue in
            guard let self = self else { return }
            switch recieveValue {
            case .didLoadPreviousSession(let previousSession):
                if previousSession.count == 0 {
                    publisher.send(.didLoadPreviousSession(nil))
                } else {
                    publisher.send(.didLoadPreviousSession(previousSession))
                }
            default:
                return
            }
        }.store(in: &subscriptions)
    }
}
