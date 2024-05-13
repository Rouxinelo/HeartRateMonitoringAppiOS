//
//  JSONDataEncoder.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 11/05/2024.
//

import Foundation

struct JSONDataEncoder {
    let encoder = JSONEncoder()
    
    func encodeToJSON(_ data: Encodable) -> Data? {
        do {
            let data = try encoder.encode(data)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}
