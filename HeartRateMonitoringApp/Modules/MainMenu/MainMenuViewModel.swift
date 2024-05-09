//
//  MainMenuViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/05/2024.
//

import Foundation
import Combine

enum MainMenuPublisherCases {
    case didLoadUserData(User)
    case didLoadUserSessions([Session])
    case didLoadSignableSessions([Session])
    case error
}

class MainMenuViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<MainMenuPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func fetchUserData(for username: String) {
        networkManager.performGetRequest(apiPath: .getUserData(username))
    }
    
    func bind() {
        bindUser()
    }
    
    func bindUser() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .loadUserData(let user):
                guard let user = user else {
                    self.publisher.send(.error)
                    return
                }
                self.publisher.send(.didLoadUserData(user))
            }
        }.store(in: &subscriptions)
    }
}
