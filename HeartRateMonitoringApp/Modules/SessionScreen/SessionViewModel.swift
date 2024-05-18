//
//  SessionViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/05/2024.
//

import Foundation
import Combine

enum SessionPublisherCases {
    case didFailSendHeartrateDate
    case didGetHeartRateValue(Int)
}

class SessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<SessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var sessionData: SessionData?
    var timer: Timer? = nil
    @Published var sessionTime: Int = 0
    @Published var sessionTimeString: String = "00h 00m 00s"
    @Published var measurements = [Int]()
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
    }
    
    func setSessionData(_ sessionData: SessionData) {
        self.sessionData = sessionData
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTime()
            self.appendRandomValue()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func sendHeartrateData(username: String, sessionId: String, heartrate: Int) {
        networkManager.performRequest(apiPath: .sendHeartRateData(HeartRateData(username: username,
                                                                                sessionId: sessionId,
                                                                                heartRate: heartrate)))
    }
}

private extension SessionViewModel {
    func bind() {
        bindNetworkResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { response in
            switch response {
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func updateTime() {
        sessionTime += 1
        sessionTimeString = "\(getFormattedHours(sessionTime))h \(getFormattedMinutes(sessionTime % 3600))m \(getFormattedSeconds(sessionTime % 60))s"
    }
    
    // Mock Methods (remove after integrate sensors and backend)
    func appendRandomValue() {
        guard let sessionData = sessionData else { return }
        let value = Int.random(in: 70...110)
        measurements.append(value)
        sendHeartrateData(username: sessionData.user.username,
                          sessionId: sessionData.session.id,
                          heartrate: value)
    }
    
    func getFormattedHours(_ time: Int) -> String {
        let hours = time/3600
        return hours >= 10 ? "\(time/3600)" : "0\(time/3600)"
        
    }
    
    func getFormattedMinutes(_ time: Int) -> String {
        let hours = time/60
        return hours >= 10 ? "\(time/60)" : "0\(time/60)"
    }
    
    func getFormattedSeconds(_ time: Int) -> String {
        return time >= 10 ? "\(time)" : "0\(time)"
    }
}
