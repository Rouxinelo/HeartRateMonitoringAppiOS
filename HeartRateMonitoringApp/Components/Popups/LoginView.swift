//
//  LoginView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 19/03/2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    @Binding var isShowing: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var yOffset: CGFloat = 1000
    
    var onLogin: (String, String) -> Void
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                Image(LoginScreenIcons.heartIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Spacer(minLength: 20)
                Text(localized(LoginViewStrings.loginString))
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                
                CustomTextField(searchText: $username, 
                                isPrivateField: false,
                                placeholder: localized(LoginViewStrings.usernameString))
                .padding()
                
                CustomTextField(searchText: $password, 
                                isPrivateField: true,
                                placeholder: localized(LoginViewStrings.passwordString))
                .padding(.horizontal)
                
                Button(action: {
                    onLogin(username, password)
                    close()
                }) {
                    Text(localized(LoginViewStrings.loginString))
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 150)
                        .background(username.isEmpty || password.isEmpty ? Color.gray : Color.red)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(username.isEmpty || password.isEmpty)
                Spacer()
            }
            .frame(width: 250, height: 350)
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
    LoginView(isShowing: .constant(true), onLogin: { _,_ in })
}
