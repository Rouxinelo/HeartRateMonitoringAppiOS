//
//  RegisterUserViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation
import Combine
class RegisterUserViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<MainMenuPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    func register(for user: User) {
    }
}
