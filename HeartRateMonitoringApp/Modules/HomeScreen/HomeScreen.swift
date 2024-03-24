//
//  HomeScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/03/2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var path = NavigationPath()
    @State private var showingAlert = false
    @State private var showingFailedLoginAlert = false
    @State private var showingLogin = false
    @State private var showingLanguageSelector = false
    @State private var showingToast = false
    @State private var isLoading = false
    @State private var userType: UserType = .guest
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(spacing: 30) {
                    Image(LoginScreenIcons.heartIcon)
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text(HomeScreenStrings.titleString)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding()
                    VStack(spacing: 20) {
                        HStack(spacing: 10) {
                            Button(action: {
                                self.showingLogin = true
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
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                            Button(action: {
                                showingToast = true
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
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        
                        HStack(spacing: 10) {
                            Button(action: {
                                self.showingAlert = true
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
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                            Button(action: {
                                showingLanguageSelector = true
                            }) {
                                VStack(spacing:0) {
                                    Spacer()
                                    Image(systemName: HomeScreenIcons.settingsIcon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                    Text(HomeScreenStrings.languageString)
                                        .font(.headline)
                                        .padding()
                                }
                                .frame(width: 150, height: 100, alignment: .center)
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                }
                if showingAlert {
                    CustomAlert(isShowing: $showingAlert, 
                                icon: HomeScreenIcons.alertIcon,
                                title: HomeScreenStrings.guestAlertTitle,
                                leftButtonText: "Cancel",
                                rightButtonText: "Ok",
                                description: HomeScreenStrings.guestAlertDescription,
                                leftButtonAction: {},
                                rightButtonAction: { enterAsGuest() }, 
                                isSingleButton: false)
                }
                if showingFailedLoginAlert {
                    CustomAlert(isShowing: $showingFailedLoginAlert,
                                icon: HomeScreenIcons.alertIcon,
                                title: HomeScreenStrings.guestAlertTitle,
                                leftButtonText: "Cancel",
                                rightButtonText: "",
                                description: HomeScreenStrings.guestAlertDescription,
                                leftButtonAction: {},
                                rightButtonAction: {},
                                isSingleButton: true)
                }
                if showingLogin {
                    LoginView(isShowing: $showingLogin, 
                              onLogin: { username, password in
                        performLogin(username: username, password: password)
                    })
                }
                if showingLanguageSelector {
                    LanguageSelectorView(isShowing: $showingLanguageSelector, 
                                         onLanguageChange: { handleLanguageSelection()
                    })
                }
                if showingToast {
                    CustomToast(isShowing: $showingToast, iconName: "info.circle.fill", message: "Coming Soon")
                }
                if isLoading {
                    LoadingView(isShowing: $isLoading, title: HomeScreenStrings.loginLoadingTitle, description: HomeScreenStrings.loginLoadingDescription)
                }
            }
            .navigationDestination(for: UserType.self) { screenID in
                MainMenu(path: $path, userType: userType)
            }
        }
    }
    
    func enterAsGuest() {
        userType = .guest
        path.append(userType)
        showingAlert = false
    }
    
    func performLogin(username: String, password: String) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Implement login logic here
            if username == "Teste", password == "teste" {
                loginSuccessful(username: username)
            } else {
                showingFailedLoginAlert = true
            }
        }
        print("Username: \(username), Password \(password)")
    }
    
    func loginSuccessful(username: String) {
        userType = .login(username)
        path.append(userType)
    }
    
    func handleLanguageSelection() {
        guard let languageCode = UserDefaults.standard.string(forKey: "AppLanguage") else { return }
        print("New Selected Language: \(languageCode)")
    }
}

#Preview {
    HomeScreen()
}
