//
//  TeacherSessionViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/11/2024.
//

import Foundation
import Combine

enum SessionEvent {
    case enterSession
    case leaveSession
}

enum TeacherSessionCases {
    case didEnterSession(String)
    case didLeaveSession(String)
    case networkError
    case didCreateSummaryData(TeacherSessionSummaryData)
}

class TeacherSessionViewModel: ObservableObject {
    let sseManager = SSENetworkManager()
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<TeacherSessionCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var timer: Timer? = nil
    var sessionTime: Int = 0
    @Published var sessionUserData = [TeacherSessionUserData]()
    @Published var sessionTimeString: String = "00h 00m 00s"

    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
    }
    
    func startListening(sessionId: String) {
        sseManager.performRequest(apiPath: .session(sessionId))
            .sink { [weak self] response in
                switch response {
                case .didRecieveSSEResponse(let sseData):
                    switch sseData.event {
                    case SSEDataEvents.enterSession:
                        self?.handleEnterSession(sseData)
                    case SSEDataEvents.leaveSession:
                        self?.handleLeaveSession(sseData)
                    case SSEDataEvents.heartRate:
                        self?.handleHeartRateInput(sseData)
                    default:
                        return
                    }
                case .failedRequest:
                    self?.publisher.send(.networkError)
                }
            }.store(in: &subscriptions)
    }
    
    func stopListening() {
        sseManager.disconnect()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func finishSession(sessionName: String, sessionId: String) {
        networkManager.performRequest(apiPath: .closeSession(SessionCloseData(sessionId: sessionId)))
        publisher.send(.didCreateSummaryData(TeacherSessionSummaryData(sessionName: sessionName,
                                                                       sessionTime: sessionTimeString, 
                                                                       sessionUserData: sessionUserData)))
    }
}

private extension TeacherSessionViewModel {
    func handleEnterSession(_ sseData: SSEData) {
        if let index = sessionUserData.firstIndex(where: { $0.username == sseData.username}) {
            sessionUserData[index].isActive = true
        } else if let userData = createNewUserData(sseData) {
            sessionUserData.append(userData)
            publisher.send(.didEnterSession(userData.name))
        }
    }
    
    func handleLeaveSession(_ sseData: SSEData) {
        if let index = sessionUserData.firstIndex(where: { $0.username == sseData.username && $0.isActive}) {
            sessionUserData[index].isActive = false
            publisher.send(.didLeaveSession(sessionUserData[index].name))
        }
    }
    
    func handleHeartRateInput(_ sseData: SSEData) {
        if let index = sessionUserData.firstIndex(where: { $0.username == sseData.username && $0.isActive}), 
            let measurement = Int(sseData.value) {
            sessionUserData[index].measurements.append(measurement)
        }
    }
    
    func createNewUserData(_ sseData: SSEData) -> TeacherSessionUserData? {
        guard sseData.event == SSEDataEvents.enterSession else { return nil }
        return TeacherSessionUserData(username: sseData.username, name: sseData.value, measurements: [])
    }
    
    func updateTime() {
        sessionTime += 1
        sessionTimeString = "\(getFormattedHours(sessionTime))h \(getFormattedMinutes(sessionTime % 3600))m \(getFormattedSeconds(sessionTime % 60))s"
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

