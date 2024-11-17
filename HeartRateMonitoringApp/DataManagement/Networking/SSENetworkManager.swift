//
//  SSENetworkManager.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/11/2024.
//

import Foundation
import Combine

enum SSENetworkManageResponse {
    case didRecieveSSEResponse(SSEData)
    case failedRequest
}

class SSENetworkManager: NSObject, URLSessionDataDelegate {
    private var urlSession: URLSession?
    private var task: URLSessionDataTask?
    private let decoder = JSONDataDecoder()
    private let statePublisher = PassthroughSubject<SSENetworkManageResponse, Never>()

    func performRequest(apiPath: API) -> AnyPublisher<SSENetworkManageResponse, Never> {
        guard let url = URL(string: apiPath.path) else {
            statePublisher.send(.failedRequest)
            return statePublisher.eraseToAnyPublisher()
        }
        let sessionConfig = URLSessionConfiguration.default
        urlSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        task = urlSession?.dataTask(with: url)
        task?.resume()
        return statePublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func disconnect() {
        task?.cancel()
        urlSession?.invalidateAndCancel()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let sseData = decoder.decodeSSEResponse(data: data) else { return }
        statePublisher.send(.didRecieveSSEResponse(sseData))
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSE connection failed: \(error.localizedDescription)")
        }
    }
    
    func handleSSEResponse(response: SSEData) {
        statePublisher.send(.didRecieveSSEResponse(response))
    }
}
