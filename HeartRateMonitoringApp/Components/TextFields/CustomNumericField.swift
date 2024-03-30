//
//  CustomNumericField.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct CustomNumericField: View {
    @FocusState private var isTextFieldFocused: Bool
    @Binding var numberText: String
    @State var placeHolder: String
    @State private var isValid = true
    
    var body: some View {
        HStack {
            TextField(placeHolder, text: $numberText)
                .background(Color.white)
                .font(.headline)
                .padding()
                .background(Color.white)
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused)
                .onChange(of: numberText) {
                    let filtered = numberText.filter { $0.isNumber }
                    if filtered != numberText || numberText.count > 3 {
                        numberText = String(filtered.prefix(3))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isTextFieldFocused ? Color.red : Color.gray, lineWidth: 2)
                )
        }
    }
}

#Preview {
    CustomNumericField(numberText: .constant(""), placeHolder: "Insert Number")
}
