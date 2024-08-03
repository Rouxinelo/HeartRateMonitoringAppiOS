//
//  SensorManager.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 16/06/2024.
//

import Foundation
import MovesenseApi
import Combine

enum SensorManagerPublisherCases {
    case didConnectToDevice(MovesenseDevice)
    case didDisconnectDevice(MovesenseDevice)
    case didDiscoverNewDevice(MovesenseDevice)
    case didGetHeartRate(MovesenseHeartRate)
    case didGetEcg(MovesenseEcg)
    case didGetSystemEnergy(MovesenseSystemEnergy)
}

class SensorManager: ObservableObject {
    var api: MovesenseApi? = Movesense.api
    var device: MovesenseDevice?
    var operation: MovesenseOperation?
    var publisher = PassthroughSubject<SensorManagerPublisherCases, Never>()

    func performOperation(_ resourceType: MovesenseResourceType) {
        switch resourceType {
        case .systemEnergy, .ecgInfo, .info:
            self.requestInfo(resourseType: resourceType)
        case .heartRate, .ecg:
            self.performRequest(resourceType)
        default:
            print(SensorManagerConstants.operationNotImplemented)
        }
    }
    
    func scanForDevices() {
        guard let api = self.api else { return }
        api.resetScan()
        api.addObserver(self)
        api.startScan()
    }
    
    func stopScanning() {
        guard let api = self.api else { return }
        api.stopScan()
    }
    
    func connectToDevice(_ device: MovesenseDevice) {
        guard let api = self.api else { return }
        api.connectDevice(device)
    }
    
    func disconnectDevice() {
        guard let api = self.api, let device = self.device else { return }
        api.disconnectDevice(device)
    }
}

// MARK: - Event Handling
extension SensorManager: Observer {
    func handleEvent(_ event: ObserverEvent) {
        if let event = event as? MovesenseObserverEventOperation {
            handleEventOperation(event)
        } else if let event = event as? MovesenseObserverEventDevice {
            handleEventDevice(event)
        } else if let event = event as? MovesenseObserverEventApi, let api = self.api {
            handleEventApi(event, api)
        } else {
            print(SensorManagerConstants.invalidEvent)
        }
    }
}

// MARK: - Private Methods for working with the sensors
private extension SensorManager {
    func requestInfo(resourseType: MovesenseResourceType) {
        guard let api = self.api, let device = self.device else { return }
        let request = MovesenseRequest(resourceType: resourseType, method: MovesenseMethod.get,
                                       parameters: nil)
        api.sendRequestForDevice(device, request: request) { response in
            guard case let MovesenseObserverEventOperation.operationResponse(operationResponse) = response else {
                return
            }
            self.handleRecievedInfo(response: operationResponse, device: device)
        }
    }
    
    func performRequest(_ resourceType: MovesenseResourceType) {
        guard let device = self.device, let resource = getResource(resourceType, device) else { return }
        let movesenseRequest = MovesenseRequest(resourceType: resourceType,
                                                method: .subscribe,
                                                parameters: getParameters(for: [1], resource))
        operation = device.sendRequest(movesenseRequest, observer: self)
    }
    
    func getParameters(for indexes: [Int], _ resource: MovesenseResource) -> [MovesenseRequestParameter]? {
        switch resource.resourceType {
        case .ecg:
            return indexes.compactMap { index in
                return resource.requestParameter(index)
            }
        default:
            return nil
        }
    }
    
    func getResource(_ resourceType: MovesenseResourceType, _ device: MovesenseDevice) -> MovesenseResource? {
        let availableResources = getAllResources(for: device)
        return availableResources.first { $0.resourceType == resourceType }
    }
    
    func getAllResources(for device: MovesenseDevice) -> [MovesenseResource] {
        return device.resources
    }
}

// MARK: Handler for recieved events
extension SensorManager {
    func handleEvent(_ event: MovesenseEvent) {
        if case let MovesenseEvent.heartRate(_, hrData) = event {
            publisher.send(.didGetHeartRate(hrData))
        } else if case let MovesenseEvent.ecg(_, ecgArray) = event {
            publisher.send(.didGetEcg(ecgArray))
        }
    }
    
    func handleRecievedInfo(response: MovesenseResponse, device: MovesenseDevice) {
        if case let MovesenseResponse.systemEnergy(_, _, systemEnergy) = response {
            publisher.send(.didGetSystemEnergy(systemEnergy))
        } else if case MovesenseResponse.info(_, _, _) = response {
            print(SensorManagerConstants.operationNotImplemented)
        } else if case MovesenseResponse.ecgInfo(_, _, _) = response {
            print(SensorManagerConstants.operationNotImplemented)
        }
    }
    
    func handleEventOperation(_ operation: MovesenseObserverEventOperation) {
        switch operation {
        case .operationError(_):
            print(SensorManagerConstants.simpleError)
        case .operationEvent(let event):
            print(SensorManagerConstants.simpleEvent)
            handleEvent(event)
        case .operationResponse(_):
            print(SensorManagerConstants.response)
        default:
            print(SensorManagerConstants.operationFinished)
        }
    }
    
    func handleEventDevice(_ operation: MovesenseObserverEventDevice) {
        switch operation {
        case .deviceConnected(let device):
            print("\(device) \(SensorManagerConstants.connected)")
        case .deviceConnecting(let device):
            print("\(device) \(SensorManagerConstants.connecting)")
        case .deviceDisconnected(let device):
            print("\(device) \(SensorManagerConstants.disconnected)")
        case .deviceError(let device, _):
            print("\(device) \(SensorManagerConstants.error)")
        case .deviceOperationInitiated(let device, operation: _):
            print("\(device) \(SensorManagerConstants.operation)")
        }
    }
    
    func handleEventApi(_ operation: MovesenseObserverEventApi, _ api: MovesenseApi) {
        switch operation {
        case .apiDeviceConnected(let device):
            print("\(SensorManagerConstants.api) \(device) \(SensorManagerConstants.connected)")
            self.device = device
            publisher.send(.didConnectToDevice(device))
        case .apiDeviceConnecting(let device):
            print("\(SensorManagerConstants.api) \(device) \(SensorManagerConstants.connecting)")
        case .apiDeviceDisconnected(let device):
            publisher.send(.didDisconnectDevice(device))
        case .apiDeviceDiscovered(let device):
            print("\(SensorManagerConstants.api) \(device) \(SensorManagerConstants.discovered)")
            publisher.send(.didDiscoverNewDevice(device))
        case .apiDeviceOperationInitiated(let device, operation: _):
            print("\(SensorManagerConstants.api) \(device) \(SensorManagerConstants.operation)")
        case .apiError(_):
            print(SensorManagerConstants.simpleError)
        }
    }
}

struct SensorManagerConstants {
    static let operationNotImplemented: String = "NOT YET IMPLEMENTED"
    static let invalidEvent: String = "ERROR: INVALID EVENT"
    static let simpleError: String = "ERROR"
    static let simpleEvent: String = "EVENT"
    static let response: String = "RESPONSE RECIEVED"
    static let operationFinished: String = "OPERATION FINISHED"
    static let api: String = "API"
    // States
    static let connected: String = "State: CONNECTED"
    static let connecting: String = "State: CONNECTING"
    static let disconnected: String = "State: DISCONNECTED"
    static let error: String = "State: ERROR"
    static let discovered: String = "State: DISCOVERED"
    static let operation: String = "State: OPERATION INITIATED"
}
