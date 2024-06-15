//
//  RegisterUserViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation
import Combine

enum RegisterUserPublisherCases {
    case didRegisterSuccessfully
    case emailAlreadyRegistered
    case usernameAlreadyRegistered
    case error
}

class RegisterUserViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<RegisterUserPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func register(for user: RegisterUser) {
        networkManager.performRequest(apiPath: .register(user))
    }
    
    func bind() {
        bindNetworkResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .registerUserResult(let registerUserResult):
                switch registerUserResult {
                case .usernameAlreadyRegistered:
                    self.publisher.send(.usernameAlreadyRegistered)
                case .emailAlreadyRegistered:
                    self.publisher.send(.emailAlreadyRegistered)
                case .registerSuccessful:
                    self.publisher.send(.didRegisterSuccessfully)
                }
            default:
                self.publisher.send(.error)
            }
        }.store(in: &subscriptions)
    }
}
