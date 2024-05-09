//
//  JSONDataDecoder.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 06/05/2024.
//

import Foundation

struct JSONDataDecoder {
    let decoder = JSONDecoder()
    
    func decodeUserData(data: Data) -> User? {
        do {
            let userData = try decoder.decode(User.self, from: data)
            return userData
        } catch {
            return nil
        }
    }
    
    func decodeSessions(data: Data) -> [Session]? {
        do {
            let sessions = try decoder.decode([Session].self, from: data)
            return sessions
        } catch {
            return nil
        }
    }
}
