//
//  HomeViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/05/2024.
//

import Foundation
import Combine

enum HomePublisherCases {
    case didLoginSuccessfully(String)
    case loginFailed
}

class HomeViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<HomePublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var username: String?
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func bind() {
        bindNetworkResponse()
    }
    
    func attemptLogin(username: String, password: String) {
        self.username = username
        networkManager.performRequest(apiPath: .login(UserLogin(username: username, password: password)))
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self, let username = self.username else {
                self?.publisher.send(.loginFailed)
                return
            }
            switch response {
            case .didLogin:
                publisher.send(.didLoginSuccessfully(username))
            default:
                publisher.send(.loginFailed)
            }
        }.store(in: &subscriptions)
    }
}
