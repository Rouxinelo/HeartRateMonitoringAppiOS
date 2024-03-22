//
//  MainMenuSection.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 21/03/2024.
//

import SwiftUI

struct MainMenuSection: View {
    let sectionColor: Color
    let sectionIcon: String
    let sectionTitle: String
    let sectionDescription: String
    let isGuestMode: Bool
    let sectionAction: (() -> Void)
    
    var body: some View {
        Button(action: {
            if !isGuestMode { sectionAction() }
        }) {
            ZStack {
                VStack(spacing:0) {
                    Image(systemName: isGuestMode ? MainMenuSectionIcons.warningIcon : sectionIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.top, 20)
                    Text(sectionTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Text(isGuestMode ? "Unavailable in Guest Mode": sectionDescription)
                }
                .frame(width: 180, height: 200, alignment: .top)
                .background(isGuestMode ? .gray : sectionColor)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .disabled(isGuestMode)
    }
}

#Preview {
    MainMenuSection(sectionColor: .red, sectionIcon: "arrow.clockwise.circle", sectionTitle: "Test", sectionDescription: "Test Description", isGuestMode: false, sectionAction: {})
}
