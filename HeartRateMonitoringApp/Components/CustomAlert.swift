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
    let description: String
    let onOK: () -> Void
    let onCancel: () -> Void
        
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
                        onCancel()
                        close()
                    }, label: {
                        Text("Cancel")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    })
                    
                    Button(action: {
                        onOK()
                        close()
                    }, label: {
                        Text("Ok")
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
    CustomAlert(isShowing: .constant(true), icon: "exclamationmark.circle", title: "Test Title", description: "Test Description", onOK: {}, onCancel: {})
}

