//
//  CustomAlert.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/03/2024.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var isShowing: Bool
    @State private var yOffset: CGFloat = 1000

    let icon: String
    let title: String
    let leftButtonText: String
    let rightButtonText: String
    let description: String
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    var isSingleButton: Bool
        
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            VStack(spacing: 20) {
                
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.red)
                
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        leftButtonAction()
                        close()
                    }, label: {
                        Text(leftButtonText)
                            .padding()
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    })
                    if !isSingleButton {
                        Button(action: {
                            rightButtonAction()
                            close()
                        }, label: {
                            Text(rightButtonText)
                                .padding()
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        })
                    }
                }
            }
            .frame(width: 300)
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

