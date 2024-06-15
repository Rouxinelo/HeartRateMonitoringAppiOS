//
//  SessionDetailViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation
import Combine

enum SessionDetailPublisherCases {
    case didSignInSuccessfully
    case error
}

class SessionDetailViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<SessionDetailPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func signIn(for username: String, sessionId: String) {
        networkManager.performRequest(apiPath: .signInSession(username, sessionId))
    }
    
    func bind() {
        bindNetworkResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .didSignInSession:
                self.publisher.send(.didSignInSuccessfully)
            default:
                self.publisher.send(.error)
            }
        }.store(in: &subscriptions)
    }
}
