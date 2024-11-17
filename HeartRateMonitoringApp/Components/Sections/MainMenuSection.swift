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
    let isUnavailable: Bool
    let sectionAction: (() -> Void)
    
    var body: some View {
        Button(action: {
            if !isUnavailable { sectionAction() }
        }) {
            ZStack {
                VStack(spacing:0) {
                    Image(systemName: isUnavailable ? MainMenuSectionIcons.warningIcon : sectionIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.top, 20)
                    Text(sectionTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Text(isUnavailable ? "Unavailable in Guest Mode": sectionDescription)
                }
                .frame(width: 180, height: 200, alignment: .top)
                .background(isUnavailable ? .gray : sectionColor)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .disabled(isUnavailable)
    }
}
