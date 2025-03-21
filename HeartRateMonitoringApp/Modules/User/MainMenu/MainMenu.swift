//
//  MainMenu.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/03/2024.
//

import SwiftUI

struct MainMenu: View {
    
    private struct Constants {
        static let guestUser: String = "Guest"
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State private var showingAlert = false
    @State private var isLogoutLoading = false
    @State private var isUserDataLoading = false
    @State private var areSessionsLoading = false
    @State private var showErrorToast = false
    @State private var showTokenAlert = false
    @StateObject var viewModel = MainMenuViewModel()
    
    let userType: UserType
    
    var body: some View {
        ZStack {
            VStack {
                Text(getUserType())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            VStack (spacing: 20) {
                Image(LoginScreenIcons.heartIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .center)
                Text(localized(MainMenuStrings.sectionsTitle))
                    .font(.title)
                    .fontWeight(.bold)
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .red,
                                    sectionIcon: MainMenuIcons.myClassesIcon,
                                    sectionTitle: localized(MainMenuStrings.classesSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.classesSectionDescription),
                                    isUnavailable: isGuest(),
                                    sectionAction: {
                        goToUserSessions()
                    })
                    MainMenuSection(sectionColor: .green,
                                    sectionIcon: MainMenuIcons.calendarIcon,
                                    sectionTitle: localized(MainMenuStrings.calendarSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.calendarSectionDescription),
                                    isUnavailable: false,
                                    sectionAction: {
                        guard let user = getUser() else { 
                            fetchCalendarSessions(for: Constants.guestUser)
                            return
                        }
                        fetchCalendarSessions(for: user.username)
                    })
                }
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .yellow,
                                    sectionIcon: MainMenuIcons.userIcon,
                                    sectionTitle: localized(MainMenuStrings.userInfoSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.userInfoSectionDescription),
                                    isUnavailable: isGuest(),
                                    sectionAction: {
                        goToUserDetail()
                    })
                    MainMenuSection(sectionColor: .blue,
                                    sectionIcon: MainMenuIcons.logoutIcon,
                                    sectionTitle: isGuest() ? localized(MainMenuStrings.leaveSectionsTitle) : localized(MainMenuStrings.logoutSectionsTitle),
                                    sectionDescription: localized(MainMenuStrings.logoutSectionDescription),
                                    isUnavailable: false,
                                    sectionAction: {
                        showingAlert = true })
                }
            }.padding()
            
            if showingAlert {
                CustomAlert(isShowing: $showingAlert,
                            icon: HomeScreenIcons.alertIcon,
                            title: localized(MainMenuStrings.logoutAlertTitle),
                            leftButtonText: localized(MainMenuStrings.logoutSectionCancel),
                            rightButtonText: localized(MainMenuStrings.logoutSectionOk),
                            description: localized(MainMenuStrings.logoutAlertDescription),
                            leftButtonAction: {},
                            rightButtonAction: { beginLogoutAnimation() },
                            isSingleButton: false)
            }
            
            if isLogoutLoading {
                LoadingView(isShowing: $isLogoutLoading,
                            title: localized(MainMenuStrings.loadingViewTitle),
                            description: localized(MainMenuStrings.loadingViewDescription))
            }
            if isUserDataLoading {
                LoadingView(isShowing: $isLogoutLoading,
                            title: localized(MainMenuStrings.userDataLoadingTitle),
                            description: localized(MainMenuStrings.userDataLoadingDescription))
            }
            if areSessionsLoading {
                LoadingView(isShowing: $areSessionsLoading,
                            title: localized(MainMenuStrings.userDataLoadingTitle),
                            description: localized(MainMenuStrings.userDataLoadingDescription))
            }
            if showErrorToast {
                CustomToast(isShowing: $showErrorToast,
                            iconName: "info.circle.fill",
                            message: localized(MainMenuStrings.networkErrorToast))
            }
            
            if showTokenAlert {
                InvalidTokenAlert(isShowing: $showTokenAlert,
                                  path: $path)
            }
            
        }.navigationDestination(for: [UserDetail].self, destination: { detail in
            UserDetailsScreen(details: detail)
        }).navigationDestination(for: [Session].self, destination: { sessions in
            CalendarScreen(path: $path, isGuest: isGuest(), username: getUser()?.username, sessions: sessions)
        }).navigationDestination(for: User.self, destination: { user in
            UserSessionsScreen(path: $path, user: user)
        }).onReceive(viewModel.publisher) { recievedValue in
            switch recievedValue {
            case .didLoadUserData(let userData):
                isUserDataLoading = false
                path.append(userData)
            case .didLoadUserSessions(_):
                return
            case .didLoadSignableSessions(let sessions):
                areSessionsLoading = false
                goToCalendar(with: sessions)
            case .invalidToken:
                showTokenAlert = true
            case .error:
                isUserDataLoading = false
                areSessionsLoading = false
                showErrorToast = true
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func goToUserSessions() {
        guard let user = getUser() else { return }
        path.append(user)
    }
    
    func fetchCalendarSessions(for user: String) {
        viewModel.fetchCalendarSessions(for: user)
    }
    
    func goToCalendar(with sessions: [Session]) {
        path.append(sessions)
    }
    
    func goToUserDetail() {
        guard case let .login(user) = userType else { return }
        isUserDataLoading = true
        viewModel.fetchUserData(for: user.username)
    }
    
    func logout() {
        isLogoutLoading = false
        presentationMode.wrappedValue.dismiss()
    }
    
    func beginLogoutAnimation() {
        showingAlert = false
        if case let .login(user) = userType {
            viewModel.logout(for: user.username)
        }
        isLogoutLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            logout()
        }
    }
    
    func getUserType() -> String {
        switch userType {
        case .guest:
            return localized(MainMenuStrings.welcomeStringGuest)
        case .login(let user):
            return localized(MainMenuStrings.welcomeStringUser) + user.username
        }
    }
    
    func isGuest() -> Bool {
        switch userType {
        case .guest:
            return true
        case .login(_):
            return false
        }
    }
    
    func getUser() -> User? {
        switch userType {
        case .guest:
            return nil
        case .login(let user):
            return user
        }
    }
}
