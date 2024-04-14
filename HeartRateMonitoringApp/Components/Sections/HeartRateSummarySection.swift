//
//  HeartRateSummarySection.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 14/04/2024.
//

import SwiftUI

struct HeartRateSummarySection: View {
    var sectionIcon: String
    var sectionTitle: String
    var sectionDescription: String
    var sectionColor: Color
    var foregroundColor: Color = .white
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(systemName: sectionIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(.top)
                    .fontWeight(.bold)
                Text(sectionTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical)
                Text(sectionDescription)
                    .fontWeight(.bold)
            }
            .frame(width: 180, height: 140, alignment: .top)
            .background(sectionColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(20)
        }
    }
}

#Preview {
    HeartRateSummarySection(sectionIcon: "arrow.up", 
                            sectionTitle: "Average",
                            sectionDescription: "Test Description",
                            sectionColor: .red)
}
