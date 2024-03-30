//
//  SearchTextField.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $searchText)
                .padding()
                .background(Color.white)
                .font(.headline)
            if !searchText.removeSpaces().isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            Spacer()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red, lineWidth: 2)
        )
        .padding()
    }
}

#Preview {
    SearchTextField(searchText: .constant(""), placeholder: "Search")
}
