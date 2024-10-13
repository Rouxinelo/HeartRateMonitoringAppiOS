//
//  TeacherJoinableSessionsViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 10/10/2024.
//

import Foundation
import Combine

enum TeacherJoinableSessionsCases {
    case sessionsLoaded([Session])
    case noSessionsLoaded
    case sessionJoinSuccessful
    case sessionJoinFailed
}

class TeacherJoinableSessionsViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<TeacherJoinableSessionsCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bindNetworkResponse()
    }
    
    func loadSessions(_ teacher: String) {
        networkManager.performRequest(apiPath: .getTeacherSessions(teacher, .joinable))
    }
    
    func cancelSession(teacher: String, sessionId: String) {
        networkManager.performRequest(apiPath: .cancelSession(teacher, sessionId))
    }
}

private extension TeacherJoinableSessionsViewModel {
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
                publisher.send(.sessionJoinSuccessful)
            case .didFailCancelSession:
                publisher.send(.sessionJoinFailed)
            default:
                return
            }
        }.store(in: &subscriptions)
    }
}
