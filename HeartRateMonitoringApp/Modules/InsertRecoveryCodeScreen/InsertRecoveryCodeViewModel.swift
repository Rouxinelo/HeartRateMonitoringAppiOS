//
//  InsertRecoveryCodeViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 06/08/2024.
//

import Foundation
import Combine

enum InsertRecoveryCodeCases {
    case emailSentSuccessful
    case emailSendFailed
    case passwordChangeSuccessful
    case passwordChangeFailed
    case error
}

class InsertRecoveryCodeViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<InsertRecoveryCodeCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bindNetworkManagerResponse()
    }
    
    func sendRecoveryEmail(_ recoveryData: RecoveryEmailData) {
        networkManager.performRequest(apiPath: .sendRecoveryEmail(recoveryData))
    }
    
    func changePassword(_ passwordChangeData: PasswordChangeData) {
        networkManager.performRequest(apiPath: .changePassword(passwordChangeData))
    }
}

private extension InsertRecoveryCodeViewModel {
    func bindNetworkManagerResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .didSendRecoveryEmail:
                publisher.send(.emailSentSuccessful)
            case .didNotSendRecoveryEmail:
                publisher.send(.emailSendFailed)
            case .didChangePassword:
                publisher.send(.passwordChangeSuccessful)
            case .didFailChangePassword:
                publisher.send(.passwordChangeFailed)
            default:
                publisher.send(.error)
            }
        }.store(in: &subscriptions)
    }
}
