//
//  PasswordRecoveryViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 04/08/2024.
//

import Foundation
import Combine

enum PasswordRecoveryCases {
    case didFindUser(User, Int)
    case didNotFindUser
}

class PasswordRecoveryViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<PasswordRecoveryCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bindNetworkManagerResponse()
    }
    
    func searchForUser(_ username: String) {
        networkManager.performRequest(apiPath: .getUserData(username))
    }
}

private extension PasswordRecoveryViewModel {
    func bindNetworkManagerResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .loadUserData(let user):
                guard let user = user else {
                    self.publisher.send(.didNotFindUser)
                    return
                }
                publisher.send(.didFindUser(user, generateRecoveryCode()))
            default:
                self.publisher.send(.didNotFindUser)
            }
        }.store(in: &subscriptions)
    }
    
    func generateRecoveryCode() -> Int {
        return Int.random(in: 10000...99999)
    }
}
