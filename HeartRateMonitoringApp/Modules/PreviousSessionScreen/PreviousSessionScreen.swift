//
//  PreviousSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import SwiftUI
import UIKit

struct PreviousSessionScreen: View {
    @Environment(\.presentationMode) var presentationMode
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
                        back()
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
                
                VStack (spacing: 10){
                    Text("Actions:").font(.title).fontWeight(.bold)
                    HStack {
                        Button(action: {
                            captureScreenshot(of: SessionShareabaleView(sessionData: sessionData), event: .share)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Save")
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 120)
                            .padding()
                        }
                        .background(.red)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                        
                        Button(action: {
                            captureScreenshot(of: SessionShareabaleView(sessionData: sessionData), event: .share)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 120)
                            .padding()
                        }
                        .background(.red)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                    }
                }
                Spacer()
            }
        }
            .navigationBarBackButtonHidden()
    }
    
    func captureScreenshot(of customView: some View, event: ScreenShotEvent = .share) {
        let hostingController = UIHostingController(rootView: customView)
        hostingController.view.frame = UIScreen.main.bounds
        let renderer = UIGraphicsImageRenderer(bounds: hostingController.view.bounds)
        
        let screenshot = renderer.image { ctx in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        switch event {
        case .save:
            saveScreenShot(screenshot)
        case .share:
            shareScreenShot(screenshot)
        }
    }
    
    func shareScreenShot(_ screenshot: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        if let topViewController = window.rootViewController {
            topViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func saveScreenShot(_ screenshot: UIImage) {
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
    }
    
    func getAverage(_ array: [Int]) -> Int {
        return array.isEmpty ? 0 : array.reduce(0, +) / array.count
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
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
