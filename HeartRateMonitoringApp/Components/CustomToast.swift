//
//  CustomToast.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 22/03/2024.
//

import SwiftUI

struct CustomToast: View {
    @Binding var isShowing: Bool
    @State private var yOffset: CGFloat = -200

    var iconName: String
    var message: String
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: iconName)
                        .foregroundColor(.red)
                    Text(message)
                        .font(Font.headline)
                        .foregroundColor(.black)
                    Spacer(minLength: 10)
                    Button {
                        close()
                    } label: {
                        Image(systemName: CustomToastIcons.xIcon)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.white)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .shadow(radius: 10)
                .offset(y: yOffset)
                .animation(.spring())
                Spacer()
            }
            .padding(.top, 20)
        }.onAppear {
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
    CustomToast(isShowing: .constant(true), iconName: "info.circle.fill", message: "Test Message")
}
