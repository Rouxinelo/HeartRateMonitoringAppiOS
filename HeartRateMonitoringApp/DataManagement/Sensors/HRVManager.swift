import Foundation
import Combine

enum ECGManagerState {
    case didSetHRV(Double)
}

class HRVManager {
    let milissecondToSecondRate: Double = 1000
    let minRange: Int = 300
    let maxRange: Int = 2000
    let publisher = PassthroughSubject<ECGManagerState, Never>()
    private var rrIntervals: [Int] = []
    
    func addSamples(samples: [Int]) {
        rrIntervals.append(contentsOf: filterOutliers(samples: samples))
    }
    
    func calculateSDNN() {
        guard rrIntervals.count >= 2 else {
            return
        }
        let rrIntervalsSeconds = rrIntervals.map { Double($0) / milissecondToSecondRate }
        let meanRR = rrIntervalsSeconds.reduce(0, +) / Double(rrIntervalsSeconds.count)
        let variances = rrIntervalsSeconds.map { pow($0 - meanRR, 2) }
        let sdnn = sqrt(variances.reduce(0, +) / Double(rrIntervalsSeconds.count))
        print(sdnn * milissecondToSecondRate)
        publisher.send(.didSetHRV(sdnn * milissecondToSecondRate))
    }
    
    private func filterOutliers(samples: [Int]) -> [Int] {
        guard !samples.isEmpty else { return samples }
        let plausibleRange = minRange...maxRange
        let filteredSamples = samples.filter { plausibleRange.contains($0) }
        let localWindowSize = 5
        var cleanedSamples: [Int] = []
        
        for i in 0..<filteredSamples.count {
            let windowStart = max(0, i - localWindowSize / 2)
            let windowEnd = min(filteredSamples.count - 1, i + localWindowSize / 2)
            let window = Array(filteredSamples[windowStart...windowEnd])
            let windowMean = Double(window.reduce(0, +)) / Double(window.count)
            let deviation = abs(Double(filteredSamples[i]) - windowMean) / windowMean
            if deviation <= 0.2 {
                cleanedSamples.append(filteredSamples[i])
            }
        }
        return cleanedSamples
    }
}
