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
    
    func decodeResponse(data: Data) -> PostResponse? {
        do {
            let response = try decoder.decode(PostResponse.self, from: data)
            return response
        } catch {
            return nil
        }
    }
    
    func decodePreviousSession(data: Data) -> PreviousSessionData? {
        do {
            let response = try decoder.decode(PreviousSessionData.self, from: data)
            return response
        } catch {
            return nil
        }
    }
    
    func decodeTeacherData(data: Data) -> Teacher? {
        do {
            let userData = try decoder.decode(Teacher.self, from: data)
            return userData
        } catch {
            return nil
        }
    }
    
    func decodeSSEResponse(data: Data) -> SSEData? {
        do {
            let sseData = try decoder.decode(SSEData.self, from: data)
            return sseData
        } catch {
            return nil
        }
    }
}
