//
//  HrvSection.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 27/01/2025.
//

import SwiftUI

struct HrvSection: View {
    @Binding var hrv: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 4)
                .overlay(
                    HStack(spacing: 0) {
                        Image(systemName: "waveform.path.ecg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                        Spacer()
                        VStack {
                            Text(localized(PreviousSessionStrings.hrvDataString))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Text("\(hrv)ms")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        Image(getHrvImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.red)
                    }
                    .padding()
                )
        }
        .frame(width: 300, height: 70, alignment: .center)
    }
    
    func getHrvImage() -> String {
        hrv < 30 ? "face-sad" : "face-happy"
    }
}
