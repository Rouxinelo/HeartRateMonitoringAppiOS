//
//  HomeScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/03/2024.
//

import SwiftUI
import MovesenseApi

struct HomeScreen: View {
    @State private var path = NavigationPath()
    @State private var showingAlert = false
    @State private var showingFailedLoginAlert = false
    @State private var showingLogin = false
    @State private var showingLanguageSelector = false
    @State private var showingToast = false
    @State private var isLoading = false
    @State private var userType: UserType = .guest
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(spacing: 30) {
                    Image(LoginScreenIcons.heartIcon)
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text(localized(HomeScreenStrings.titleString))
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
                                    Text(localized(HomeScreenStrings.loginString))
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                .frame(width: 150, height: 100, alignment: .center)
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                            Button(action: {
                                goToRegisterScreen()
                            }) {
                                VStack(spacing:0) {
                                    Spacer()
                                    Image(systemName: HomeScreenIcons.registerIcon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                    Text(localized(HomeScreenStrings.registerString))
                                        .font(.headline)
                                        .fontWeight(.bold)
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
                                    Text(localized(HomeScreenStrings.guestString))
                                        .font(.headline)
                                        .fontWeight(.bold)
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
                                    Text(localized(HomeScreenStrings.languageString))
                                        .font(.headline)
                                        .fontWeight(.bold)
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
                                title: localized(HomeScreenStrings.guestAlertTitle),
                                leftButtonText: localized(HomeScreenStrings.guestAlertCancel),
                                rightButtonText: localized(HomeScreenStrings.guestAlertContinue),
                                description: localized(HomeScreenStrings.guestAlertDescription),
                                leftButtonAction: {},
                                rightButtonAction: { enterAsGuest() }, 
                                isSingleButton: false)
                }
                if showingFailedLoginAlert {
                    CustomAlert(isShowing: $showingFailedLoginAlert,
                                icon: HomeScreenIcons.alertIcon,
                                title: localized(HomeScreenStrings.loginFailedTitle),
                                leftButtonText: localized(HomeScreenStrings.guestAlertContinue),
                                rightButtonText: "",
                                description: localized(HomeScreenStrings.loginFailedDescription),
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
                    CustomToast(isShowing: $showingToast,
                                iconName: HomeScreenIcons.toastIcon,
                                message: localized(HomeScreenStrings.registeredToastMessage))
                }
                if isLoading {
                    LoadingView(isShowing: $isLoading, title: localized(HomeScreenStrings.loginLoadingTitle), 
                                description: localized(HomeScreenStrings.loginLoadingDescription))
                }
            }
            .navigationDestination(for: UserType.self) { _ in
                MainMenu(path: $path, userType: userType)
            }
            .navigationDestination(for: String.self) { screenId in
                if screenId == ScreenIds.registerScreenID {
                    RegisterUserScreen(showRegisterToast: $showingToast)
                }
            }.onReceive(viewModel.publisher) { receiveValue in
                isLoading = false
                switch receiveValue {
                case .didLoginSuccessfully(let username):
                    loginSuccessful(username: username)
                case .loginFailed:
                    showingFailedLoginAlert = true
                }
            }.onAppear {
                let x = Movesense.api
                print(x.mdsVersion())
            }
        }
    }
    
    func goToRegisterScreen() {
        path.append(ScreenIds.registerScreenID)
    }
    
    func enterAsGuest() {
        userType = .guest
        path.append(userType)
        showingAlert = false
    }
    
    func performLogin(username: String, password: String) {
        isLoading = true
        viewModel.attemptLogin(username: username, password: password)
    }
    
    func loginSuccessful(username: String) {
        userType = .login(getMockUser(username))
        path.append(userType)
    }
    
    func handleLanguageSelection() {
        guard let languageCode = UserDefaults.standard.string(forKey: "AppLanguage") else { return }
        print("New Selected Language: \(languageCode)")
    }
    
    func getMockUser(_ username: String) -> User {
        return User(username: username, 
                    firstName: "TestName",
                    lastName: "TestName",
                    email: "testmail@test.com",
                    gender: "M",
                    age: 18,
                    password: "testPassword")
    }
}

#Preview {
    HomeScreen()
}
