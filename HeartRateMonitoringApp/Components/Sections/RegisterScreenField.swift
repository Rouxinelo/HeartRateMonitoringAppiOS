//
//  RegisterScreenField.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct RegisterScreenField: View {
    @Binding var searchText: String
    @State var isHiddenField: Bool
    @State var placeholder: String
    @State var title: String
    @State var description: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title).font(.headline).fontWeight(.bold)
                Spacer()
            }
            CustomTextField(searchText: $searchText, isPrivateField: isHiddenField, placeholder: placeholder)
            HStack {
                Text(description).foregroundStyle(.gray)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
