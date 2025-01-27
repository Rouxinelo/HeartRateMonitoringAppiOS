import Foundation
import Combine

enum ECGManagerState {
    case didSetHRV(Double)
}

class ECGManager {
    public var publisher = PassthroughSubject<ECGManagerState, Never>()
    
    private let samplingRate: Int
    private let samplesPerWindow: Int
    private var samplesBuffer: [Int] = []
    private(set) var hrv: Double?

    init(samplingRate: Int) {
        self.samplingRate = samplingRate
        self.samplesPerWindow = 10 * samplingRate
    }

    func process(samples: [Int]) {
        samplesBuffer.append(contentsOf: samples)
        while samplesBuffer.count >= samplesPerWindow {
            let tenSecondChunk = Array(samplesBuffer.prefix(samplesPerWindow))
            samplesBuffer.removeFirst(samplesPerWindow)
            let rrIntervals = detectRPeaksAndCalculateRR(from: tenSecondChunk)
            hrv = HRVCalculator.calculateRMSSD(from: rrIntervals)
            if let hrv = hrv {
                publisher.send(.didSetHRV(hrv))
            }
        }
    }

    private func detectRPeaksAndCalculateRR(from samples: [Int]) -> [Double] {
        let filteredSamples = applyBandPassFilter(to: samples)
        guard filteredSamples.count >= 3 else { return [] }
        let threshold = calculateAdaptiveThreshold(from: filteredSamples)
        let rPeakIndices = detectRPeaks(in: filteredSamples, threshold: threshold)
        return calculateRRIntervals(from: rPeakIndices)
    }

    private func applyBandPassFilter(to samples: [Int]) -> [Double] {
        let alpha = 0.95
        var highPassValue: Double = 0.0
        var lowPassValue: Double = 0.0

        return samples.map { sample in
            let x = Double(sample)
            highPassValue = alpha * (highPassValue + x - highPassValue)
            lowPassValue += (highPassValue - lowPassValue) * 0.5
            return lowPassValue
        }
    }

    private func calculateAdaptiveThreshold(from samples: [Double]) -> Double {
        let median = samples.sorted()[samples.count / 2]
        let noiseFloor = median * 0.5
        return max(noiseFloor, 200.0)
    }

    private func detectRPeaks(in samples: [Double], threshold: Double) -> [Int] {
        var rPeakIndices: [Int] = []

        for i in 1..<samples.count - 1 where samples[i] > threshold {
            if samples[i] > samples[i - 1] && samples[i] > samples[i + 1] {
                rPeakIndices.append(i)
            }
        }

        return rPeakIndices
    }

    private func calculateRRIntervals(from rPeakIndices: [Int]) -> [Double] {
        let minRR = 0.3
        let maxRR = 2.0
        return zip(rPeakIndices.dropFirst(), rPeakIndices)
            .map { Double($0 - $1) / Double(samplingRate) }
            .filter { $0 >= minRR && $0 <= maxRR }
    }
}

class HRVCalculator {
    static func calculateRMSSD(from rrIntervals: [Double]) -> Double? {
        guard rrIntervals.count > 1 else { return nil }
        let squaredDifferences = zip(rrIntervals.dropFirst(), rrIntervals)
            .map { pow(($0 - $1) * 1000, 2) }
        let meanSquaredDiff = squaredDifferences.reduce(0, +) / Double(squaredDifferences.count)
        return sqrt(meanSquaredDiff)
    }
}
