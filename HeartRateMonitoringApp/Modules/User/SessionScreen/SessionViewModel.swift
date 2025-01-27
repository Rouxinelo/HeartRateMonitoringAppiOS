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
    case didFetchSamplingRate
}

class SessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<SessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var sessionData: SessionData?
    var sensorManager: SensorManager?
    var ecgManager: ECGManager?
    var timer: Timer? = nil
    var sessionTime: Int = 0
    var lastMeasurement: Int = 0
    @Published var sessionTimeString: String = "00h 00m 00s"
    @Published var measurements = [Int]()
    @Published var hrv: Int = 0
    
    func setSensorManager(_ sensorManager: SensorManager) {
        self.sensorManager = sensorManager
        sensorManager.performOperation(.ecgInfo)
        bind()
    }
    
    func setSessionData(_ sessionData: SessionData) {
        self.sessionData = sessionData
    }
    
    func startTimer() {
        guard let sensorManager = sensorManager else { return }
        sensorManager.performOperation(.heartRate)
        sensorManager.performOperation(.ecg)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        sensorManager?.disconnectDevice()
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
            case .didGetEcg(let movesenseECG):
                self.processECGSamples(movesenseECG.samples.map { Int($0) })
            case .didGetEcgInfo(let ecgInfo):
                self.ecgManager = ECGManager(samplingRate: Int(ecgInfo.currentSampleRate))
                bindECGManagerResponse()
                DispatchQueue.main.async { [weak self] in
                    self?.publisher.send(.didFetchSamplingRate)
                }
            default:
                return
            }
        }.store(in: &subscriptions)
    }
    
    func bindECGManagerResponse() {
        guard let ecgManager = ecgManager else { return }
        ecgManager.publisher.sink { [weak self] response in
            guard let self = self, let sessionData = sessionData else { return }
            switch response {
            case .didSetHRV(let hrv):
                self.didGetHrv(Int(hrv))
                self.networkManager.performRequest(apiPath: .sendHrvData(HRVData(username: sessionData.username, sessionId: sessionData.session.id, hrv: Int(hrv))))
            }
        }.store(in: &subscriptions)
    }
    
    func handleMeasurementRecieved(_ measurement: Int) {
        lastMeasurement = measurement
    }
    
    func processECGSamples(_ samples: [Int]) {
        guard let ecgManager = ecgManager else { return }
        ecgManager.process(samples: samples)
    }
    
    func didGetHrv(_ hrv: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.hrv = hrv
        }
    }
    
    func getSessionSummaryData() -> SessionSummaryData? {
        guard let sessionData = sessionData, let device = sensorManager?.device else { return nil }
        return SessionSummaryData(sensor: DeviceRepresentable(name: device.localName),
                                  username: sessionData.username,
                                  session: sessionData.session,
                                  measurements: measurements,
                                  hrv: hrv,
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
    
    func getAverage(_ array: [Int]) -> Int {
        return array.isEmpty ? 0 : array.reduce(0, +) / array.count
    }
}
