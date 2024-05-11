//
//  MainMenuViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/05/2024.
//

import Foundation
import Combine

enum MainMenuPublisherCases {
    case didLoadUserData([UserDetail])
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
    
    func fetchCalendarSessions(for username: String) {
        networkManager.performGetRequest(apiPath: .getAllSessions(username))
    }
    
    func bind() {
        bindNetworkResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .loadUserData(let user):
                guard let user = user else {
                    self.publisher.send(.error)
                    return
                }
                self.publisher.send(.didLoadUserData(getUserDetail(for: user)))
            case .loadCalendarSessions(let sessions):
                guard let sessions = sessions else {
                    self.publisher.send(.error)
                    return
                }
                self.publisher.send(.didLoadSignableSessions(sessions))
            default:
                self.publisher.send(.error)
            }
        }.store(in: &subscriptions)
    }
    
    func getUserDetail(for user: User) -> [UserDetail] {
        [UserDetail(detailType: .name, description: "\(user.firstName) \(user.lastName)".shortenFirstName() ),
            UserDetail(detailType: .age, description: String(user.age)),
            UserDetail(detailType: .gender, description: user.gender),
            UserDetail(detailType: .email, description: user.email)]
    }
}
