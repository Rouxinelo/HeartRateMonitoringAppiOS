//
//  CreateSessionViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/08/2024.
//

import Foundation
import Combine

enum CreateSessionCases {
    case didCreateSession
    case didFailCreateSession
    case error
}

class CreateSessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<CreateSessionCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bindNetworkManagerResponse()
    }
    
    func createSession(with creationData: SessionCreationData) {
        networkManager.performRequest(apiPath: .createSession(creationData))
    }
}

private extension CreateSessionViewModel {
    func bindNetworkManagerResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .createSessionSuccessful:
                publisher.send(.didCreateSession)
            case .createSessionFailed:
                publisher.send(.didFailCreateSession)
            default:
                publisher.send(.error)
            }
        }.store(in: &subscriptions)
    }
}
