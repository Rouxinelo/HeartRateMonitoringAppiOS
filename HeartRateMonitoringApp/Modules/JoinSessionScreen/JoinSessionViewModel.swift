//
//  JoinSessionViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/06/2024.
//

import Foundation
import Combine

enum JoinSessionPublisherCases {
    case didEnterSession(device: MockDevice)
    case didFailOperation
}

class JoinSessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<JoinSessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var device: MockDevice?
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func sendEnterData(username: String, sessionId: String, device: MockDevice) {
        self.device = device
        networkManager.performRequest(apiPath: .enterSession(username, sessionId))
    }
}

private extension JoinSessionViewModel {
    func bind() {
        bindNetworkResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .sessionOperationSuccessful:
                if let device = device {
                    publisher.send(.didEnterSession(device: device))
                }
            default:
                publisher.send(.didFailOperation)
            }
        }.store(in: &subscriptions)
    }
}
