//
//  PasswordRecoveryViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 04/08/2024.
//

import Foundation
import Combine

enum PasswordRecoveryCases {
    case didFindUser
    case didNotFindUser
}

class PasswordRecoveryViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<PasswordRecoveryCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    func searchForUser(_ username: String) {
        if username == "test" {
            publisher.send(.didFindUser)
        } else {
            publisher.send(.didNotFindUser)
        }
    }
    
    func generateRecoveryCode() -> Int {
        return Int.random(in: 10000...99999)
    }
}
