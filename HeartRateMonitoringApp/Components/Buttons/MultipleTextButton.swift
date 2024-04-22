//
//  MultipleTextButton.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/04/2024.
//

import SwiftUI

struct MultipleTextButton: View {
    @State var action: (() -> Void)
    @State var title: String
    @State var description: String
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                VStack(spacing: 5) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    Text(description)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                Image(systemName: "chevron.right")
                    .foregroundStyle(.red)
                    .padding()
            }.frame(height: 100)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
        }
    }
}

#Preview {
    MultipleTextButton(action: {},
                       title: "ExampleTitle",
                       description: "ExampleDescription")
}
