//
//  UserDetailsSection.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct UserDetailsSection: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .foregroundColor(.red)
                .padding(.leading)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 5)
                HStack {
                    Text(description)
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom, 5)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.leading)
        .padding(.trailing)
        .shadow(radius: 5)
    }
}

#Preview {
    UserDetailsSection(image: "exclamationmark.circle", title: "Test Title", description: "Test Description")
}
