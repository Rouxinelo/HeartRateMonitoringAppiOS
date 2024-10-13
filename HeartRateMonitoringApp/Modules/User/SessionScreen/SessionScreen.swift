//
//  SessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/04/2024.
//

import SwiftUI
import Charts

struct SessionScreen: View {
    @Binding var path: NavigationPath
    @State var sessionData: SessionData
    @State var sensorManager: SensorManager
    @State private var showingCloseAlert: Bool = false
    @State private var animationAmount: CGFloat = 1
    @State var shouldShowSummaryToast: Bool = false
    @StateObject var viewModel = SessionViewModel()
    var maximumChartValues: Int = 5
    
    var body: some View {
        ZStack {
            VStack (spacing: 25) {
                HStack (alignment: .center) {
                    VStack (alignment: .leading) {
                        Text(sessionData.session.name).font(.largeTitle).fontWeight(.bold)
                        SessionInfoSection(imageName: "person.fill",
                                           text: sessionData.session.teacher,
                                           spacing: 15)
                        SessionInfoSection(imageName: "sensor.tag.radiowaves.forward.fill",
                                           text: sessionData.device.name)
                        SessionInfoSection(imageName: viewModel.getBatteryPercentageImage(sessionData.device.batteryPercentage ?? 100),
                                           text: "\(sessionData.device.batteryPercentage ?? 100)%")
                    }
                    Spacer()
                    Button(action: {
                        didTapClose()
                    }) {
                        VStack {
                            Image(systemName: "xmark")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.title2)
                            Text(localized(SessionStrings.closeString))
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.headline)
                        }
                    }
                }
                VStack (spacing: 0) {
                    Text(localized(SessionStrings.timeString))
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(viewModel.sessionTimeString)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    Text(localized(SessionStrings.heartRateInfoString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Image(systemName: "heart.fill")
                         .resizable()
                         .frame(width: 50, height: 50)
                         .foregroundColor(.red)
                         .scaleEffect(animationAmount)
                         .animation(
                            .linear(duration: 0.5)
                                 .repeatForever(autoreverses: true),
                             value: animationAmount)
                         .onAppear {
                             animationAmount = 1.2
                         }
                    Text(localized(SessionStrings.currentHeartRateString).replacingOccurrences(of: "$", with: "\(viewModel.measurements.last ?? 0)"))
                        .font(.headline)
                        .fontWeight(.bold)
                    GeometryReader { geometry in
                        ZStack {
                            Path { path in
                                for i in 0..<self.lastFiveValues(viewModel.measurements).count {
                                    let x = (geometry.size.width / CGFloat(maximumChartValues - 1)) * CGFloat (i)
                                    let y = geometry.size.height * (1 - CGFloat(self.lastFiveValues(viewModel.measurements)[i]) / 150)
                                    if i == 0 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(Color.red, lineWidth: 2)
                            ForEach(0..<self.lastFiveValues(viewModel.measurements).count, id: \.self) { i in
                                let x = (geometry.size.width / CGFloat(maximumChartValues - 1)) * CGFloat (i)
                                let y = geometry.size.height * (1 - CGFloat(self.lastFiveValues(viewModel.measurements)[i]) / 150)
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .position(x: x, y: y)
                                Text("\(Int(self.lastFiveValues(viewModel.measurements)[i]))")
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
                        VStack {
                            Text(localized(SessionStrings.minString))
                                .font(.headline)
                                .fontWeight(.bold).frame(alignment: .leading)
                            Text("\(viewModel.measurements.min() ?? 0) \(localized(SessionStrings.bpmString))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                        VStack {
                            Text(localized(SessionStrings.maxString))
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(viewModel.measurements.max() ?? 0) \(localized(SessionStrings.bpmString))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                        VStack {
                            Text(localized(SessionStrings.averageString))
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(getAverage(viewModel.measurements)) \(localized(SessionStrings.bpmString))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                }
                Spacer()
            }.padding(.horizontal)
            
            if showingCloseAlert {
                CustomAlert(isShowing: $showingCloseAlert,
                            icon: "exclamationmark.circle",
                            title: localized(SessionStrings.closeAlertTitleString),
                            leftButtonText: localized(SessionStrings.closeAlertLeftButtonString),
                            rightButtonText: localized(SessionStrings.closeAlertRightButtonString),
                            description: localized(SessionStrings.closeAlertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: { closeSession() },
                            isSingleButton: false)
            }
        }.navigationDestination(for: SessionSummaryData.self, destination: { sessionSummaryData in
            SessionSummaryScreen(path: $path,
                                 showingToast: shouldShowSummaryToast,
                                 sessionSummary: sessionSummaryData)
        })
        .onReceive(viewModel.publisher) { result in
            switch result {
            case .didFailSendHeartrateDate:
                return
            case .didLeaveSession(let summaryData):
                path.append(summaryData)
            case .didLeaveSeassonFailedConnection(let summaryData):
                shouldShowSummaryToast = false
                path.append(summaryData)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.setSessionData(sessionData)
            viewModel.setSensorManager(sensorManager)
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
    func lastFiveValues(_ array: [Int]) -> [Int] {
        let count = min(array.count, 5)
        return Array(array.suffix(count))
    }
    
    func getAverage(_ array: [Int]) -> Int {
        return array.isEmpty ? 0 : array.reduce(0, +) / array.count
    }
    
    func didTapClose() {
        showingCloseAlert = true
    }
    
    func closeSession() {
        viewModel.didTapClose()
    }
}

#Preview {
    SessionScreen(path: .constant(NavigationPath()),
                  sessionData: SessionData(session: SessionSimplified(id: "testId",
                                                                      name: "Pilates Clinico",
                                                                      teacher: "Joao Rouxinol"),
                                           username: "testUsername", 
                                           device: DeviceRepresentable(name: "Movesense 1234",
                                                                       batteryPercentage: 10)),
                  sensorManager: SensorManager())
}
