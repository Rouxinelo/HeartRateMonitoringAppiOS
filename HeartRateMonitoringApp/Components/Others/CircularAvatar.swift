//
//  CircularAvatar.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct CircularAvatar: View {
    let backgroundColor: Color
    let textColor: Color
    let text: String
    var body: some View {
        Circle()
            .fill(backgroundColor) // Customize the fill color of the circle
            .frame(width: 75, height: 75) // Adjust the size of the circle
            .overlay(
                Text(text)
                    .foregroundColor(textColor) // Customize the text color
                    .font(.largeTitle).fontWeight(.bold) // Customize the font size
            ).shadow(radius: 10)
    }
}
