//
//  CustomAlert.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/03/2024.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var isShowing: Bool
    
    let icon: String
    let title: String
    let leftButtonText: String
    let rightButtonText: String
    let description: String
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
        
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack(spacing: 20) {
                
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                
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
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    })
                    
                    Button(action: {
                        rightButtonAction()
                        close()
                    }, label: {
                        Text(rightButtonText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    })
                }
            }
            .frame(width: 300)
            .padding(30)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
        }
        .ignoresSafeArea()
    }
    
    func close() {
        isShowing = false
    }
}

#Preview {
    CustomAlert(isShowing: .constant(true), icon: "exclamationmark.circle", title: "Test Title", leftButtonText: "left", rightButtonText: "right", description: "Test Description", leftButtonAction: {}, rightButtonAction: {})
}

