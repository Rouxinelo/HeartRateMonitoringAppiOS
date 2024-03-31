//
//  SearchTextField.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct CustomTextField: View {
    @FocusState private var isTextFieldFocused: Bool
    @Binding var searchText: String
    var isPrivateField: Bool
    var placeholder: String
    
    var body: some View {
        ZStack {
            HStack {
                TextField(placeholder, text: $searchText)
                    .padding()
                    .background(Color.white)
                    .font(.headline)
                    .focused($isTextFieldFocused)
                    .blur(radius: isPrivateField ? 3 : 0)
                if !searchText.removeSpaces().isEmpty {
                    Button(action: {
                        searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                Spacer()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isTextFieldFocused ? Color.red : Color.gray, lineWidth: 2)
            )
        }
    }
}

#Preview {
    CustomTextField(searchText: .constant(""), isPrivateField: false, placeholder: "Search")
}
