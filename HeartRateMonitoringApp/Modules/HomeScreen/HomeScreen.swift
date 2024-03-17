//
//  HomeScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/03/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [Color.backgroundLightYellow, Color.backgroundLightOrange]),
                           startPoint: .topLeading,
                           endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                        // Squared view with rounded edges
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(uiColor: .lightGray))
                    .frame(width: 250, height: 250)
                    .overlay(
                        Text(HomeScreenStrings.titleString)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                    )
                    .padding()


                        
                        // Button stack
                        VStack(spacing: 20) {
                            Button(action: {
                                // Action for Login button
                            }) {
                                Text(HomeScreenStrings.loginString)
                                    .padding()
                                    .background(Color.buttonDarkBlue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                // Action for Continue As Guest button
                            }) {
                                Text(HomeScreenStrings.guestString)
                                    .padding()
                                    .background(Color.buttonDarkBlue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                // Action for Settings button
                            }) {
                                Text(HomeScreenStrings.settingsString)
                                    .padding()
                                    .background(Color.buttonDarkBlue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
        }
    }
}

#Preview {
    HomeScreen()
}
