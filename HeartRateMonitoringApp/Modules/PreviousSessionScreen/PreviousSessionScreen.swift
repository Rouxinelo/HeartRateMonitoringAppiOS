//
//  PreviousSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import SwiftUI
import UIKit
import Combine
struct PreviousSessionScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var sessionData: PreviousSessionData
    @State var subscriptions = Set<AnyCancellable>()
    @State var showSuccessToast: Bool = false
    @State var showFailureToast: Bool = false
    let screenshotManager = ScreenshotManager()
    
    var body: some View {
        ZStack {
            VStack (spacing: 20) {
                HStack (alignment: .center) {
                    VStack (alignment: .leading) {
                        Text(localized(PreviousSessionStrings.titleString))
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
                        back()
                    }) {
                        VStack {
                            Image(systemName: "xmark")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.title2)
                            Text(localized(PreviousSessionStrings.closeButtonString))
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.headline)
                        }.frame(alignment: .topTrailing)
                    }
                }.padding(.horizontal)
                
                VStack (spacing: 10) {
                    Text(localized("previous_sessions_hrData"))
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        HeartRateSummarySection(sectionIcon: "number",
                                                sectionTitle: localized(PreviousSessionStrings.countSectionTitleString),
                                                sectionDescription: localized(PreviousSessionStrings.countSectionDescriptionString).replacingOccurrences(of: "$", with: "\(sessionData.measurements.count)"),
                                                sectionColor: .red)
                        HeartRateSummarySection(sectionIcon: "alternatingcurrent",
                                                sectionTitle: localized(PreviousSessionStrings.averageSectionTitleString),
                                                sectionDescription: "\(getAverage(sessionData.measurements)) " + localized(PreviousSessionStrings.bpmString),
                                                sectionColor: .blue)
                    }
                    HStack {
                        HeartRateSummarySection(sectionIcon: "arrow.up",
                                                sectionTitle: localized(PreviousSessionStrings.maxSectionTitleString),
                                                sectionDescription: "\(sessionData.measurements.max() ?? 0) " + localized(PreviousSessionStrings.bpmString),
                                                sectionColor: .green)
                        HeartRateSummarySection(sectionIcon: "arrow.down",
                                                sectionTitle: localized(PreviousSessionStrings.minSectionTitleString),
                                                sectionDescription: "\(sessionData.measurements.min() ?? 0) " + localized(PreviousSessionStrings.bpmString),
                                                sectionColor: .yellow)
                    }
                }
                
                VStack (spacing: 10){
                    Text(localized(PreviousSessionStrings.actionString)).font(.title).fontWeight(.bold)
                    HStack {
                        Button(action: {
                            screenshotManager.captureScreenshot(of: SessionShareabaleView(sessionData: sessionData), event: .save)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text(localized(PreviousSessionStrings.saveString))
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 150)
                            .padding()
                        }
                        .background(.red)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                        
                        Button(action: {
                            screenshotManager
                                .captureScreenshot(of: SessionShareabaleView(sessionData: sessionData), 
                                                                event: .share)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text(localized(PreviousSessionStrings.shareString))
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 150)
                            .padding()
                        }
                        .background(.red)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                    }
                }
                Spacer()
            }
            
            if showFailureToast {
                CustomToast(isShowing: $showFailureToast,
                            iconName: "info.circle.fill",
                            message: localized(PreviousSessionStrings.toastErrorString))
            }
            
            if showSuccessToast {
                CustomToast(isShowing: $showSuccessToast,
                            iconName: "info.circle.fill",
                            message: localized(PreviousSessionStrings.toastSuccessString))
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            bindScreenshotManager()
        }.swipeRight {
            back()
        }
    }
    
    func getAverage(_ array: [Int]) -> Int {
        return array.isEmpty ? 0 : array.reduce(0, +) / array.count
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func bindScreenshotManager() {
        screenshotManager.statePublisher.sink { result in
            switch result {
            case .success:
                showSuccessToast.toggle()
            case .failure:
                showFailureToast.toggle()
            }
        }.store(in: &subscriptions)
    }
}

#Preview {
    PreviousSessionScreen(sessionData: PreviousSessionData(session: Session(id: "testId",
                                                                            name: "Test Name",
                                                                            date: "11/11",
                                                                            hour: "11h",
                                                                            teacher: "test teacher",
                                                                            totalSpots: 10,
                                                                            filledSpots: 10),
                                                           username: UserSimplified(username: "testUsername"),
                                                           measurements: [10]))
}
