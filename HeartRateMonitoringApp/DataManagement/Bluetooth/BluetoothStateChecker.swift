//
//  BluetoothStateChecker.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 19/06/2024.
//

import Foundation
import CoreBluetooth
import Combine

enum BluetoothStateCheckerState {
    case poweredOff
    case poweredOn
    case connectionError
}

class BluetoothStateChecker: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?
    private var subscriptions = Set<AnyCancellable>()
    public var publisher = PassthroughSubject<BluetoothStateCheckerState, Never>()
    
    override init() {
        super.init()
    }
    
    func startCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            publisher.send(.poweredOff)
        case .poweredOn:
            publisher.send(.poweredOn)
        default:
            publisher.send(.connectionError)
        }
    }
}
