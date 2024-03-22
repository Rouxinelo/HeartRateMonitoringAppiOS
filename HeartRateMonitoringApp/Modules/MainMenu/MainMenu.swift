//
//  MainMenu.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/03/2024.
//

import SwiftUI

struct MainMenu: View {
    @Environment(\.presentationMode) var presentationMode
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
                Text(MainMenuStrings.sectionsTitle)
                    .font(.title)
                    .fontWeight(.bold)
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .red,
                                    sectionIcon: MainMenuIcons.myClassesIcon,
                                    sectionTitle: MainMenuStrings.classesSectionTitle,
                                    sectionDescription: MainMenuStrings.classesSectionDescription,
                                    isGuestMode: false,
                                    sectionAction: {})
                    MainMenuSection(sectionColor: .green,
                                    sectionIcon: MainMenuIcons.calendarIcon,
                                    sectionTitle: MainMenuStrings.calendarSectionTitle,
                                    sectionDescription: MainMenuStrings.calendarSectionDescription,
                                    isGuestMode: false,
                                    sectionAction: {})
                }
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .yellow,
                                    sectionIcon: MainMenuIcons.userIcon,
                                    sectionTitle: MainMenuStrings.userInfoSectionTitle,
                                    sectionDescription: MainMenuStrings.userInfoSectionDescription,
                                    isGuestMode: false,
                                    sectionAction: {})
                    MainMenuSection(sectionColor: .blue,
                                    sectionIcon: MainMenuIcons.logoutIcon,
                                    sectionTitle: isGuest() ? MainMenuStrings.leaveSectionsTitle : MainMenuStrings.logoutSectionsTitle,
                                    sectionDescription: MainMenuStrings.logoutSectionDescription,
                                    isGuestMode: false,
                                    sectionAction: { showingAlert = true })
                }
            }
            
            if showingAlert {
                CustomAlert(isShowing: $showingAlert,
                            icon: HomeScreenIcons.alertIcon,
                            title: MainMenuStrings.logoutAlertTitle,
                            leftButtonText: "Cancel",
                            rightButtonText: "Ok",
                            description: MainMenuStrings.logoutAlertDescription,
                            leftButtonAction: {},
                            rightButtonAction: { beginLogoutAnimation() })
            }
            
            if isLoading {
                LoadingView(isShowing: $isLoading, title: MainMenuStrings.loadingViewTitle, description: MainMenuStrings.loadingViewDescription)
            }
            
        }.navigationBarBackButtonHidden()
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
    MainMenu(userType: .guest)
}
