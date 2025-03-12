//
//  SessionShareabaleView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import SwiftUI

struct SessionShareabaleView: View {
    @State var sessionData: PreviousSessionData
    
    var body: some View {
        VStack (spacing: 20) {
            HStack (alignment: .center) {
                VStack (alignment: .leading) {
                    HStack {
                        Image("heart-rate").resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50, alignment: .center)
                        Text("HeartRate Monitoring App")
                            .font(.title).fontWeight(.bold)
                    }
                    Text(localized(SessionShareabaleStrings.titleString))
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
            }.padding(.horizontal)
            
            VStack (spacing: 10) {
                Text(localized(PreviousSessionStrings.heartRateDataString))
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    HeartRateSummarySection(sectionIcon: "number",
                                            sectionTitle: "Count",
                                            sectionDescription: "\(sessionData.count) Samples",
                                            sectionColor: .red)
                    HeartRateSummarySection(sectionIcon: "alternatingcurrent",
                                            sectionTitle: "Average",
                                            sectionDescription: "\(sessionData.average) BPM",
                                            sectionColor: .blue)
                }
                HStack {
                    HeartRateSummarySection(sectionIcon: "arrow.up",
                                            sectionTitle: "Maximum",
                                            sectionDescription: "\(sessionData.maximum) BPM",
                                            sectionColor: .green)
                    HeartRateSummarySection(sectionIcon: "arrow.down",
                                            sectionTitle: "Minimum",
                                            sectionDescription: "\(sessionData.minimum) BPM",
                                            sectionColor: .yellow)
                }
            }
            
            HrvSection(hrv: $sessionData.hrv)
            Spacer()
        }
    }
}
