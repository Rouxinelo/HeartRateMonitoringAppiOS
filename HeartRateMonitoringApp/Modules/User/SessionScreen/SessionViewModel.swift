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
    case didLeaveSession(SessionSummaryData)
    case didLeaveSeassonFailedConnection(SessionSummaryData)
}

class SessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<SessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var sessionData: SessionData?
    var sensorManager: SensorManager?
    var timer: Timer? = nil
    var sessionTime: Int = 0
    var lastMeasurement: Int = 0
    @Published var sessionTimeString: String = "00h 00m 00s"
    @Published var measurements = [Int]()
    
    func setSensorManager(_ sensorManager: SensorManager) {
        self.sensorManager = sensorManager
    }
    
    func setSessionData(_ sessionData: SessionData) {
        self.sessionData = sessionData
    }
    
    func startTimer() {
        guard let sensorManager = sensorManager else { return }
        bind()
        sensorManager.performOperation(.heartRate)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func sendHeartrateData(username: String, sessionId: String, heartrate: Int) {
        networkManager.performRequest(apiPath: .sendHeartRateData(HeartRateData(username: username,
                                                                                sessionId: sessionId,
                                                                                heartRate: heartrate,
                                                                                timeStamp: sessionTime)))
    }
    
    func getBatteryPercentageImage(_ batteryPercentage: Int) -> String {
        switch batteryPercentage {
        case 0..<24:
            return "battery.0percent"
        case 25..<50:
            return "battery.25percent"
        case 50..<75:
            return "battery.50percent"
        case 75..<80:
            return "battery.75percent"
        default:
            return "battery.100percent"
        }
    }
    
    func didTapClose() {
        guard let sessionData = sessionData, let sensorManager = sensorManager else { return }
        sensorManager.disconnectDevice()
        networkManager.performRequest(apiPath: .leaveSession(sessionData.username,
                                                             sessionData.session.id))
    }
}

private extension SessionViewModel {
    func bind() {
        bindNetworkResponse()
        bindSensorManagerResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self, let sessionSummaryData = getSessionSummaryData() else { return }
            switch response {
            case .sessionOperationSuccessful:
                publisher.send(.didLeaveSession(sessionSummaryData))
            case .sessionOperationFailed, .failedRequest, .urlUnavailable:
                publisher.send(.didLeaveSeassonFailedConnection(sessionSummaryData))
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
                self.handleMeasurementRecieved(Int(movesenseHeartRate.average))
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func handleMeasurementRecieved(_ measurement: Int) {
        lastMeasurement = measurement
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
        guard let sessionData = sessionData else { return }
        sessionTime += 1
        sessionTimeString = "\(getFormattedHours(sessionTime))h \(getFormattedMinutes(sessionTime % 3600))m \(getFormattedSeconds(sessionTime % 60))s"
        if lastMeasurement != 0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.measurements.append(self.lastMeasurement)
            }
            sendHeartrateData(username: sessionData.username, sessionId: sessionData.session.id, heartrate: lastMeasurement)
        }
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
