//
//  JoinSessionViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/06/2024.
//

import Foundation
import Combine
import MovesenseApi

enum JoinSessionPublisherCases {
    case didEnterSession
    case didFailOperation
    case bluetoothPoweredOn
    case bluetoothPoweredOff
    case bluetoothConnectionError
    case didDiscoverNewDevice(device: DeviceRepresentable)
    case didConnectToDevice
    case didDisconnectDevice
}

class JoinSessionViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let publisher = PassthroughSubject<JoinSessionPublisherCases, Never>()
    var subscriptions = Set<AnyCancellable>()
    var bluetoothChecker = BluetoothStateChecker()
    var sensorManager = SensorManager()
    var devices = [MovesenseDevice]()
    var deviceRepresentable: DeviceRepresentable?
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
        bind()
    }
    
    func sendEnterData(username: String, sessionId: String) {
        networkManager.performRequest(apiPath: .enterSession(username, sessionId))
    }
    
    func checkForBluetoothConnection() {
        bluetoothChecker.startCentralManager()
    }
    
    func startScanningForDevices() {
        devices.removeAll()
        sensorManager.scanForDevices()
    }
    
    func connectToDevice(_ device: DeviceRepresentable) {
        guard let device = devices.first(where: { $0.localName == device.name }) else { return }
        sensorManager.connectToDevice(device)
    }
    
    func stopScanningForDevices() {
        sensorManager.stopScanning()
    }
    
    func getSensorManager() -> SensorManager {
        sensorManager
    }
    
    func getDeviceRepresentable() -> DeviceRepresentable? {
        deviceRepresentable
    }
    
    func removeAllSubscriptions() {
        subscriptions.removeAll()
    }
    
    func handleError() {
        sensorManager.disconnectDevice()
        publisher.send(.didDisconnectDevice)
    }
}

// MARK: - Private methods
private extension JoinSessionViewModel {
    func addDeviceToModal(device: MovesenseDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.publisher.send(.didDiscoverNewDevice(device: DeviceRepresentable(name: device.localName)))
        }
    }
    
    func deviceConnected(device: MovesenseDevice) {
        sensorManager.performOperation(.systemEnergy)
    }
    
    func didGetSystemEnergy(systemEnergy: MovesenseSystemEnergy) {
        guard let device = self.sensorManager.device else { return }
        deviceRepresentable = DeviceRepresentable(name: device.localName, batteryPercentage: Int(systemEnergy.percentage))
        DispatchQueue.main.async { [weak self] in
            self?.publisher.send(.didConnectToDevice)
        }
    }
}

private extension JoinSessionViewModel {
    func bind() {
        bindNetworkResponse()
        bindBluetoothScannerResponse()
        bindSensorManagerResponse()
    }
    
    func bindNetworkResponse() {
        networkManager.statePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .sessionOperationSuccessful:
                publisher.send(.didEnterSession)
            default:
                publisher.send(.didFailOperation)
            }
        }.store(in: &subscriptions)
    }
    
    func bindBluetoothScannerResponse() {
        bluetoothChecker.publisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .poweredOff:
                publisher.send(.bluetoothPoweredOff)
            case .poweredOn:
                publisher.send(.bluetoothPoweredOn)
            case .connectionError:
                publisher.send(.bluetoothConnectionError)
            }
        }.store(in: &subscriptions)
    }
    
    func bindSensorManagerResponse() {
        sensorManager.publisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .didConnectToDevice(let movesenseDevice):
                self.stopScanningForDevices()
                self.deviceConnected(device: movesenseDevice)
            case .didDiscoverNewDevice(let movesenseDevice):
                self.devices.append(movesenseDevice)
                self.addDeviceToModal(device: movesenseDevice)
            case .didGetSystemEnergy(let systemEnergy):
                self.didGetSystemEnergy(systemEnergy: systemEnergy)
            default:
                print("Operation not supported here")
            }
        }.store(in: &subscriptions)
    }
}
