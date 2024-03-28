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
    @State private var showingToast = false
    
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
                Text(MainMenuStrings.sectionsTitle)
                    .font(.title)
                    .fontWeight(.bold)
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .red,
                                    sectionIcon: MainMenuIcons.myClassesIcon,
                                    sectionTitle: MainMenuStrings.classesSectionTitle,
                                    sectionDescription: MainMenuStrings.classesSectionDescription,
                                    isUnavailable: isGuest(),
                                    sectionAction: {
                        showingToast = true
                    })
                    MainMenuSection(sectionColor: .green,
                                    sectionIcon: MainMenuIcons.calendarIcon,
                                    sectionTitle: MainMenuStrings.calendarSectionTitle,
                                    sectionDescription: MainMenuStrings.calendarSectionDescription,
                                    isUnavailable: false,
                                    sectionAction: {
                        goToCalendar()
                    })
                }
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .yellow,
                                    sectionIcon: MainMenuIcons.userIcon,
                                    sectionTitle: MainMenuStrings.userInfoSectionTitle,
                                    sectionDescription: MainMenuStrings.userInfoSectionDescription,
                                    isUnavailable: isGuest(),
                                    sectionAction: {
                        goToUserDetail()
                    })
                    MainMenuSection(sectionColor: .blue,
                                    sectionIcon: MainMenuIcons.logoutIcon,
                                    sectionTitle: isGuest() ? MainMenuStrings.leaveSectionsTitle : MainMenuStrings.logoutSectionsTitle,
                                    sectionDescription: MainMenuStrings.logoutSectionDescription,
                                    isUnavailable: false,
                                    sectionAction: {
                        showingAlert = true })
                }
            }.padding()
            
            if showingAlert {
                CustomAlert(isShowing: $showingAlert,
                            icon: HomeScreenIcons.alertIcon,
                            title: MainMenuStrings.logoutAlertTitle,
                            leftButtonText: "Cancel",
                            rightButtonText: "Ok",
                            description: MainMenuStrings.logoutAlertDescription,
                            leftButtonAction: {},
                            rightButtonAction: { beginLogoutAnimation() },
                            isSingleButton: false)
            }
            
            if isLoading {
                LoadingView(isShowing: $isLoading,
                            title: MainMenuStrings.loadingViewTitle,
                            description: MainMenuStrings.loadingViewDescription)
            }
            
            if showingToast {
                CustomToast(isShowing: $showingToast,
                            iconName: "info.circle.fill",
                            message: "Coming Soon")
            }
        }.navigationDestination(for: [UserDetail].self, destination: { detail in
            UserDetailsScreen(details: detail)
        }).navigationDestination(for: [Session].self, destination: { sessions in
            CalendarScreen(path: $path, sessions: sessions)})
        .navigationBarBackButtonHidden()
    }
    
    func goToCalendar() {
        path.append([Session(name: "Pilates Clinico",
                             date: "24/03",
                             hour: "19h",
                             teacher: "J. Rouxinol",
                             totalSpots: 10,
                             filledSpots: 10),
                     Session(name: "Fisioterapia",
                             date: "30/03",
                             hour: "23h",
                             teacher: "J. Saias",
                             totalSpots: 15,
                             filledSpots: 5),
                     Session(name: "Yoga",
                             date: "14/04",
                             hour: "12h",
                             teacher: "John Doe",
                             totalSpots: 10,
                             filledSpots: 10),
                     Session(name: "Alongamentos",
                             date: "20/0403",
                             hour: "14h",
                             teacher: "Example Name",
                             totalSpots: 15,
                             filledSpots: 5)]
        )
    }
    
    func goToUserDetail() {
        path.append([UserDetail(detailType: .name, description: "test name"),
                     UserDetail(detailType: .email, description: "testemail@testemail.com"),
                     UserDetail(detailType: .gender, description: "M"),
                     UserDetail(detailType: .age, description: "50")])
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
            return MainMenuStrings.welcomeStringGuest
        case .login(let name):
            return MainMenuStrings.welcomeStringUser + name
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
}

#Preview {
    MainMenu(path: .constant(NavigationPath()), userType: .login("João"))
}
