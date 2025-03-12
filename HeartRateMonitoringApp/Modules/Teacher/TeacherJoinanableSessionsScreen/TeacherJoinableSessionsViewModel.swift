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
    case sessionStartSuccessful
    case sessionStartFailed
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
    
    func startSession(sessionId: String, zoomId: String, zoomPassword: String) {
        networkManager.performRequest(apiPath: .startSession(SessionStartData(sessionId: sessionId,
                                                                              zoomId: zoomId,
                                                                              zoomPassword: zoomPassword)))
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
            case .didStartSession:
                publisher.send(.sessionStartSuccessful)
            case .failedRequest:
                publisher.send(.sessionStartFailed)
            default:
                return
            }
        }.store(in: &subscriptions)
    }
}
