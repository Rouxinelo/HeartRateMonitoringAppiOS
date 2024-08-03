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
                        SessionInfoSection(imageName: "book.fill",
                                           text: sessionData.session.name,
                                           spacing: 3)
                        SessionInfoSection(imageName: "person.fill",
                                           text: sessionData.session.teacher,
                                           spacing: 11)
                        SessionInfoSection(imageName: "calendar",
                                           text: sessionData.session.date)
                        SessionInfoSection(imageName: "clock.fill",
                                           text: sessionData.session.hour,
                                           spacing: 9)
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
                                                sectionDescription: localized(PreviousSessionStrings.countSectionDescriptionString).replacingOccurrences(of: "$", with: "\(sessionData.count)"),
                                                sectionColor: .red)
                        HeartRateSummarySection(sectionIcon: "alternatingcurrent",
                                                sectionTitle: localized(PreviousSessionStrings.averageSectionTitleString),
                                                sectionDescription: "\(sessionData.average) " + localized(PreviousSessionStrings.bpmString),
                                                sectionColor: .blue)
                    }
                    HStack {
                        HeartRateSummarySection(sectionIcon: "arrow.up",
                                                sectionTitle: localized(PreviousSessionStrings.maxSectionTitleString),
                                                sectionDescription: "\(sessionData.maximum) " + localized(PreviousSessionStrings.bpmString),
                                                sectionColor: .green)
                        HeartRateSummarySection(sectionIcon: "arrow.down",
                                                sectionTitle: localized(PreviousSessionStrings.minSectionTitleString),
                                                sectionDescription: "\(sessionData.minimum) " + localized(PreviousSessionStrings.bpmString),
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
