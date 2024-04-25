//
//  PreviousSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import SwiftUI

struct PreviousSessionScreen: View {
    @Binding var path: NavigationPath
    @State private var showingAlert = false
    @State private var showingToast = false
    @State var sessionData: PreviousSessionData
    
    var body: some View {
        ZStack {
            VStack (spacing: 20) {
                HStack (alignment: .center) {
                    VStack (alignment: .leading) {
                        Text("Summary")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        HStack (spacing: 3) {
                            Image(systemName: "book.fill")
                            Text(sessionData.session.name)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack (spacing: 11) {
                            Image(systemName: "person.fill")
                            Text(sessionData.session.teacher)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack {
                            Image(systemName: "calendar")
                            Text(sessionData.session.date)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack (spacing: 9) {
                            Image(systemName: "clock.fill")
                            Text(sessionData.session.hour)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    Spacer()
                    Button(action: {
                        showingAlert = true
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
                        }.frame(alignment: .topTrailing)
                    }
                }.padding(.horizontal)
                
                VStack (spacing: 10) {
                    Text("Heart Rate Data:")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        HeartRateSummarySection(sectionIcon: "number",
                                                sectionTitle: "Count",
                                                sectionDescription: "\(sessionData.measurements.count) Samples",
                                                sectionColor: .red)
                        HeartRateSummarySection(sectionIcon: "alternatingcurrent",
                                                sectionTitle: "Average",
                                                sectionDescription: "\(getAverage(sessionData.measurements)) BPM",
                                                sectionColor: .blue)
                    }
                    HStack {
                        HeartRateSummarySection(sectionIcon: "arrow.up",
                                                sectionTitle: "Maximum",
                                                sectionDescription: "\(sessionData.measurements.max() ?? 0) BPM",
                                                sectionColor: .green)
                        HeartRateSummarySection(sectionIcon: "arrow.down",
                                                sectionTitle: "Minimum",
                                                sectionDescription: "\(sessionData.measurements.min() ?? 0) BPM",
                                                sectionColor: .yellow)
                    }
                }
                
                Button(action: {
                    showingToast = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share this summary")
                    }
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                }
                .background(.red)
                .foregroundStyle(.white)
                .cornerRadius(30)
                
                
                Spacer()
            }
            
            if showingAlert {
                CustomAlert(isShowing: $showingAlert,
                            icon: "exclamationmark.circle",
                            title: "Exit",
                            leftButtonText: "Cancel",
                            rightButtonText: "Exit",
                            description: "Leave to main menu?",
                            leftButtonAction: { showingAlert = false },
                            rightButtonAction: { didPressClose() },
                            isSingleButton: false)
            }
            
            if showingToast {
                CustomToast(isShowing: $showingToast,
                            iconName: "info.circle.fill",
                            message: "Coming Soon")
            }
            
        }
            .navigationBarBackButtonHidden()
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
    
    func getAverage(_ array: [Int]) -> Int {
        return array.isEmpty ? 0 : array.reduce(0, +) / array.count
    }
    
    func didPressClose() {
        path.removeLast()
    }
}

#Preview {
    PreviousSessionScreen(path: .constant(NavigationPath()),
                          sessionData: PreviousSessionData(session: Session(id: "testId",
                                                                            name: "Test Name",
                                                                            date: "11/11",
                                                                            hour: "11h",
                                                                            teacher: "test teacher",
                                                                            totalSpots: 10,
                                                                            filledSpots: 10),
                                                           username: UserSimplified(username: "testUsername"),
                                                           measurements: [10]))
}
