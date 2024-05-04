//
//  MainMenu.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/03/2024.
//

import SwiftUI

struct MainMenu: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State private var showingAlert = false
    @State private var isLoading = false
    
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
                        goToCalendar()
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
            
            if isLoading {
                LoadingView(isShowing: $isLoading,
                            title: localized(MainMenuStrings.loadingViewTitle),
                            description: localized(MainMenuStrings.loadingViewDescription))
            }
        }.navigationDestination(for: [UserDetail].self, destination: { detail in
            UserDetailsScreen(details: detail)
        }).navigationDestination(for: [Session].self, destination: { sessions in
            CalendarScreen(path: $path, isGuest: isGuest(), sessions: sessions)
        }).navigationDestination(for: User.self, destination: { user in
            UserSessionsScreen(path: $path, user: user)
        })
        .navigationBarBackButtonHidden()
    }
    
    func goToUserSessions() {
        guard let user = getUser() else { return }
        path.append(user)
    }
    
    func goToCalendar() {
        path.append([Session(id: "test1",
                             name: "Pilates Clinico",
                             date: "24/03",
                             hour: "19h",
                             teacher: "J. Rouxinol",
                             totalSpots: 10,
                             filledSpots: 10),
                     Session(id: "test2",
                             name: "Fisioterapia",
                             date: "30/03",
                             hour: "23h",
                             teacher: "J. Saias",
                             totalSpots: 15,
                             filledSpots: 5)]
        )
    }
    
    func goToUserDetail() {
        guard case let .login(user) = userType else { return }
        path.append(getUserDetail(for: user))
    }
    
    func getUserDetail(for user: User) -> [UserDetail] {
        [UserDetail(detailType: .name, description: "\(user.firstName) \(user.lastName)".shortenFirstName() ),
            UserDetail(detailType: .age, description: String(user.age)),
            UserDetail(detailType: .gender, description: user.gender),
            UserDetail(detailType: .email, description: user.email)]
    }
    
    func logout() {
        isLoading = false
        presentationMode.wrappedValue.dismiss()
    }
    
    func beginLogoutAnimation() {
        showingAlert = false
        isLoading = true
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

#Preview {
    MainMenu(path: .constant(NavigationPath()), 
             userType: .login(User(username: "rouxinol",
                                                                      firstName: "Joao",
                                                                      lastName: "Rouxinol",
                                                                      email: "testemail@test.com",
                                                                      gender: "M",
                                                                      age: 27,
                                                                      password: "testPassword")))
}
