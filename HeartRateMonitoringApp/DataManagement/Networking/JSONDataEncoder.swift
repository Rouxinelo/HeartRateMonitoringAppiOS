//
//  JSONDataEncoder.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation

struct JSONDataEncoder {
    let encoder = JSONEncoder()
    
    func encodeRegister(user: RegisterUser) -> Data? {
        do {
            let data = try encoder.encode(user)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}
