//
//  SessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/04/2024.
//

import SwiftUI
import Charts

struct SessionScreen: View {
    @State var sessionData: SessionData
    @State private var heartbeat = false
    @State private var sessionTime: Int = 0
    @State private var timer: Timer? = nil
    @State private var sessionTimeString: String = "00h 00m 00s"
    @State private var measurements = [Int]()
    var maximumChartValues: Int = 5
    
    var body: some View {
        ZStack {
            VStack (spacing: 30) {
                HStack (alignment: .center) {
                    VStack (alignment: .leading) {
                        Text(sessionData.session.name).font(.largeTitle).fontWeight(.bold)
                        HStack (spacing: 15) {
                            Image(systemName: "person.fill")
                            Text(sessionData.session.teacher).font(.headline).fontWeight(.bold)
                        }
                        HStack {
                            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                            Text(sessionData.device.name).font(.headline).fontWeight(.bold)
                            
                        }
                    }
                    Spacer()
                    Button(action: {
                        
                    }) {
                        VStack {
                            Image(systemName: "xmark")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.title2)
                            Text("Close")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.headline)
                        }
                    }
                }
                VStack (spacing: 0) {
                    Text("Session time:")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(sessionTimeString)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    Text("Heart rate info")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Image(systemName: "suit.heart.fill")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .foregroundStyle(.red)
                        .scaleEffect(heartbeat ? 1.1 : 1.0)
                        .animation(Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: false))
                        .onAppear() {
                            self.heartbeat.toggle()
                        }
                    Text("Current HR: \(measurements.last ?? 0)")
                        .font(.headline)
                        .fontWeight(.bold)
                    GeometryReader { geometry in
                        ZStack {
                            Path { path in
                                for i in 0..<self.lastFiveValues(measurements).count {
                                    let x = (geometry.size.width / CGFloat(maximumChartValues - 1)) * CGFloat (i)
                                    let y = geometry.size.height * (1 - CGFloat(self.lastFiveValues(measurements)[i]) / 150)
                                    if i == 0 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(Color.red, lineWidth: 2)
                            ForEach(0..<self.lastFiveValues(measurements).count, id: \.self) { i in
                                let x = (geometry.size.width / CGFloat(maximumChartValues - 1)) * CGFloat (i)
                                let y = geometry.size.height * (1 - CGFloat(self.lastFiveValues(measurements)[i]) / 150)
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .position(x: x, y: y)
                                Text("\(Int(self.lastFiveValues(measurements)[i]))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .position(x: x, y: y - 15)
                            }
                        }
                    }.padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2)
                        }.background( LinearGradient(gradient: Gradient(colors: [.white, .lightGray]), startPoint: .top, endPoint: .bottom))
                        .foregroundStyle(.black)
                        .padding(10)
                    HStack (spacing: 40) {
                        Text("Min: \(measurements.min() ?? 0)")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Max: \(measurements.max() ?? 0)")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Avg: \(getAverage(measurements) ?? 0)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                Spacer()
            }.padding(.horizontal)
        }.navigationBarBackButtonHidden()
            .onAppear {
                self.startTimer()
            }
            .onDisappear {
                self.stopTimer()
            }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateTime()
            appendRandomValue()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func updateTime() {
        sessionTime += 1
        sessionTimeString = "\(getFormattedHours(sessionTime))h \(getFormattedMinutes(sessionTime % 3600))m \(getFormattedSeconds(sessionTime % 60))s"
    }
    
    func getFormattedHours(_ time: Int) -> String {
        let hours = time/3600
        return hours >= 10 ? "\(time/3600)" : "0\(time/3600)"
        
    }
    
    func getFormattedMinutes(_ time: Int) -> String {
        let hours = time/60
        return hours >= 10 ? "\(time/60)" : "0\(time/60)"
    }
    
    func getFormattedSeconds(_ time: Int) -> String {
        return time >= 10 ? "\(time)" : "0\(time)"
    }
    
    func lastFiveValues(_ array: [Int]) -> [Int] {
        let count = min(array.count, 5)
        return Array(array.suffix(count))
    }
    
    func getAverage(_ array: [Int]) -> Int {
        return array.isEmpty ? 0 : array.reduce(0, +) / array.count
    }
    
    // Mock Methods (remove after integrate sensors)
    func appendRandomValue() {
        measurements.append(Int.random(in: 70...110))
    }
}

#Preview {
    SessionScreen(sessionData: SessionData(session: SessionSimplified(id: "testId",
                                                                      name: "Pilates Clinico",
                                                                      teacher: "Joao Rouxinol"),
                                           user: UserSimplified(username: "testUsername"),
                                           device: MockDevice(name: "Movesense 12345678",
                                                              batteryPercentage: 10)))
}
