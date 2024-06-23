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
    case didLeaveSession(SessionSummaryData)
}

class SessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<SessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var sessionData: SessionData?
    var sensorManager: SensorManager?
    var timer: Timer? = nil
    @Published var sessionTime: Int = 0
    @Published var sessionTimeString: String = "00h 00m 00s"
    @Published var measurements = [Int]()
    @Published var sensorBatteryLevel: Int?
    
    func setSensorManager(_ sensorManager: SensorManager) {
        self.sensorManager = sensorManager
        bindSensorManagerResponse()
        sensorManager.performOperation(.systemEnergy)
    }
    
    func setSessionData(_ sessionData: SessionData) {
        self.sessionData = sessionData
    }
    
    func startTimer() {
        bind()
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
    
    func getSensorName() -> String {
        guard let device = sensorManager?.device else { return "" }
        return device.localName
    }
    
    func didTapClose() {
        guard let sessionData = sessionData else { return }
        networkManager.performRequest(apiPath: .leaveSession(sessionData.username,
                                                             sessionData.session.id))
    }
}

private extension SessionViewModel {
    func bind() {
        bindNetworkResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .sessionOperationSuccessful:
                guard let sessionSummaryData = getSessionSummaryData() else { return }
                publisher.send(.didLeaveSession(sessionSummaryData))
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func bindSensorManagerResponse() {
        guard let sensorManager = sensorManager else { return }
        sensorManager.publisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .didGetHeartRate(let movesenseHeartRate):
                return
            case .didGetSystemEnergy(let movesenseSystemEnergy):
                self.sensorBatteryLevel = Int(movesenseSystemEnergy.percentage)
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func getSessionSummaryData() -> SessionSummaryData? {
        guard let sessionData = sessionData, let device = sensorManager?.device else { return nil }
        return SessionSummaryData(sensor: DeviceRepresentable(name: device.localName),
                           username: sessionData.username,
                           session: sessionData.session,
                           measurements: measurements,
                           sessionTime: sessionTime)
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
        sendHeartrateData(username: sessionData.username,
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
