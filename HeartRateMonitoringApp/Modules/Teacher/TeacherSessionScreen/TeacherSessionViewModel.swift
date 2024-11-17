//
//  TeacherSessionViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/11/2024.
//

import Foundation
import Combine


enum TeacherSessionViewModelCases {
}

class TeacherSessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<TeacherJoinableSessionsCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bindNetworkResponse()
    }
}

private extension TeacherSessionViewModel {
    func bindNetworkResponse() {}
}

