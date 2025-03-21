//
//  CustomRadioButton.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct CustomRadioButton: View {
    @Binding var isSelected: Bool
    let text: String
    
    var body: some View {
        Button(action: {
            if !isSelected {
                isSelected.toggle()
            }
        }) {
            HStack {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                Rectangle()
                    .fill(isSelected ? Color.red : Color.white)
                    .frame(width: 25, height: 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.red, lineWidth: 2)
                    )
                
            }
        }
        .buttonStyle(PlainButtonStyle())    }
}
