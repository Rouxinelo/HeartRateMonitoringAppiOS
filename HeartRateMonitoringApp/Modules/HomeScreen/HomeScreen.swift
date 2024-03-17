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
            
            VStack(spacing: 50) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(uiColor: .lightGray))
                    .frame(width: 250, height: 250)
                    .overlay(
                        Text(HomeScreenStrings.titleString)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                    )
                    .padding()
                VStack(spacing: 20) {
                    HStack(spacing: 10) {
                        Button(action: {
                            // Action for Login button
                        }) {
                            VStack(spacing:0) {
                                Spacer()
                                Image(systemName: HomeScreenIcons.loginIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                Text(HomeScreenStrings.loginString)
                                    .font(.headline)
                                    .padding()
                            }
                            .frame(width: 150, height: 100, alignment: .center)
                            .background(Color.buttonDarkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        
                        Button(action: {
                            // Action for Register button
                        }) {
                            VStack(spacing:0) {
                                Spacer()
                                Image(systemName: HomeScreenIcons.registerIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                Text(HomeScreenStrings.registerString)
                                    .font(.headline)
                                    .padding()
                            }
                            .frame(width: 150, height: 100, alignment: .center)
                            .background(Color.buttonDarkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            // Action for Continue As Guest button
                        }) {
                            VStack(spacing:0) {
                                Spacer()
                                Image(systemName: HomeScreenIcons.guestIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                Text(HomeScreenStrings.guestString)
                                    .font(.headline)
                                    .padding()
                            }
                            .frame(width: 150, height: 100, alignment: .center)
                            .background(Color.buttonDarkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        Button(action: {
                            // Action for Settings button
                        }) {
                            VStack(spacing:0) {
                                Spacer()
                                Image(systemName: HomeScreenIcons.settingsIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                Text(HomeScreenStrings.settingsString)
                                    .font(.headline)
                                    .padding()
                            }
                            .frame(width: 150, height: 100, alignment: .center)
                            .background(Color.buttonDarkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
