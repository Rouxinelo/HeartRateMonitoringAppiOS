//
//  SessionSummaryScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 14/04/2024.
//

import SwiftUI

struct SessionSummaryScreen: View {
    @State var sessionSummary: SessionSummaryData
    
    var body: some View {
        ZStack {
            VStack (spacing: 20) {
                HStack (alignment: .center) {
                    VStack (alignment: .leading) {
                        Text("Summary")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        HStack (spacing: 9) {
                            Image(systemName: "book.fill")
                            Text(sessionSummary.session.name)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack (spacing: 15) {
                            Image(systemName: "person.fill")
                            Text(sessionSummary.session.teacher)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack {
                            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                            Text(sessionSummary.sensor.name)
                                .font(.headline)
                                .fontWeight(.bold)
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
                        }.frame(alignment: .topTrailing)
                    }
                }
                Text("Details:")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack (spacing: 0) {
                    Text("Session time:")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(getFormattedHours(sessionSummary.sessionTime))h \(getFormattedMinutes(sessionSummary.sessionTime % 3600))m \(getFormattedSeconds(sessionSummary.sessionTime % 60))s")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack (spacing: 10) {
                    Text("Heart Rate data:")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        HeartRateSummarySection(sectionIcon: "number",
                                                sectionTitle: "Measurements",
                                                sectionDescription: "\(sessionSummary.measurements.count) BPM",
                                                sectionColor: .red)
                        HeartRateSummarySection(sectionIcon: "alternatingcurrent",
                                                sectionTitle: "Average",
                                                sectionDescription: "123 BPM",
                                                sectionColor: .blue)
                    }
                    HStack {
                        HeartRateSummarySection(sectionIcon: "arrow.up",
                                                sectionTitle: "Maximum",
                                                sectionDescription: "1000 BPM",
                                                sectionColor: .green)
                        HeartRateSummarySection(sectionIcon: "arrow.down",
                                                sectionTitle: "Minimum",
                                                sectionDescription: "10 BPM",
                                                sectionColor: .yellow)
                    }
                }
                Spacer()
            }.padding(.horizontal)
        }.navigationBarBackButtonHidden()
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
}

#Preview {
    SessionSummaryScreen(sessionSummary: SessionSummaryData(sensor: MockDevice(name: "Movesense 12345678", 
                                                                               batteryPercentage: 10),
                                                            user: UserSimplified(username: "rouxinol"),
                                                            session: SessionSimplified(id: "testID", 
                                                                                       name: "Test Name",
                                                                                       teacher: "Test Teacher"),
                                                            measurements: [1, 2, 3, 4, 5, 6, 7, 8],
                                                            sessionTime: 3661))
}
