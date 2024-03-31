//
//  LoadingView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 22/03/2024.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isShowing: Bool
    @State private var yOffset: CGFloat = 1000

    let title: String
    let description: String
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            VStack(spacing: 10) {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    .padding(.top, 5)
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text(description)
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            .padding(30)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .offset(y: yOffset)
            .animation(.spring())
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                yOffset = 0
            }
        }
    }
    
    func close() {
        isShowing = false
    }
}

#Preview {
    LoadingView(isShowing: .constant(true), title: "Test Title", description: "Test Description")
}
