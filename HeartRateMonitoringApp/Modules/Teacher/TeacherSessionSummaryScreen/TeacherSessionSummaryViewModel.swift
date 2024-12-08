//
//  TeacherSessionSummaryViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/11/2024.
//

import Foundation
import Combine

enum TeacherSessionSummaryCases {
    case failedRequest
}

class TeacherSessionSummaryViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<TeacherSessionSummaryCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    @Published var userSummaryData: [TeacherSessionSummaryUserData] = []

    func getUserSummaryData(for sessionSummaryData: TeacherSessionSummaryData) {
        bindNetworkResponse(with: sessionSummaryData)
        for sessionUserData in sessionSummaryData.sessionUserData {
            networkManager.performRequest(apiPath: .getUserData(sessionUserData.username))
        }
    }
}

private extension TeacherSessionSummaryViewModel {
    func bindNetworkResponse(with sessionSummaryData: TeacherSessionSummaryData) {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .loadUserData(let user):
                guard let user = user else {
                    self.publisher.send(.failedRequest)
                    return
                }
                addUserData(user: user, sessionSummaryData: sessionSummaryData)
            default:
                self.publisher.send(.failedRequest)
            }
        }.store(in: &subscriptions)
    }
    
    func addUserData(user: User, sessionSummaryData: TeacherSessionSummaryData) {
        guard let measurements = getMeasurements(user: user, sessionSummaryData: sessionSummaryData) else { return }
        DispatchQueue.main.async {
            self.userSummaryData.append(TeacherSessionSummaryUserData(user: user, measurements: measurements))
        }
    }
    
    func getMeasurements(user: User, sessionSummaryData: TeacherSessionSummaryData) -> [Int]? {
        sessionSummaryData.sessionUserData.first { $0.username == user.username }?.measurements
    }
}
