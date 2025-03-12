//
//  FutureSessionsTeacherViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/08/2024.
//

import Foundation
import Combine

enum FutureSessionsPublisherCases {
    case sessionsLoaded([Session])
    case noSessionsLoaded
    case sessionCancelSuccessful
    case sessionCancelFailed
}

class FutureSessionsTeacherViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<FutureSessionsPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bindNetworkResponse()
    }
    
    func loadSessions(_ teacher: String) {
        networkManager.performRequest(apiPath: .getTeacherSessions(teacher, .signed))
    }
    
    func cancelSession(teacher: String, sessionId: String) {
        networkManager.performRequest(apiPath: .cancelSession(teacher, sessionId))
    }
}

private extension FutureSessionsTeacherViewModel {
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .didLoadTeacherSessions(let sessions):
                guard let sessions = sessions, !sessions.isEmpty else {
                    publisher.send(.noSessionsLoaded)
                    return
                }
                publisher.send(.sessionsLoaded(sessions))
            case .didCancelSession:
                publisher.send(.sessionCancelSuccessful)
            case .didFailCancelSession:
                publisher.send(.sessionCancelFailed)
            default:
                return
            }
        }.store(in: &subscriptions)
    }
}
