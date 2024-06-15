//
//  SessionSummaryViewModel.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/05/2024.
//

import Foundation
import Combine

class SessionSummaryViewModel: ObservableObject {
    let networkManager = NetworkManager()
    var postSessionData: PostSessionData? {
        didSet {
            sendSessionSummaryData(postSessionData)
        }
    }
    
    func processSummary(_ sessionSummary: SessionSummaryData) {
        postSessionData = getPostSessionData(for: sessionSummary)
    }
}

private extension SessionSummaryViewModel {
    func sendSessionSummaryData(_ summaryData: PostSessionData?) {
        guard let summaryData = summaryData else { return }
        networkManager.performRequest(apiPath: .sendSessionSummary(summaryData))
    }
    
    func getPostSessionData(for sessionSummary: SessionSummaryData) -> PostSessionData {
        PostSessionData(username: sessionSummary.username,
                        sessionId: sessionSummary.session.id,
                        measurements: sessionSummary.measurements)
    }
}
