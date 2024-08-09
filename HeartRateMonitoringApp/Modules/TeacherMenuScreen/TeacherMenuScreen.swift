//
//  TeacherMenuScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/08/2024.
//

import SwiftUI

struct TeacherMenuScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var teacher: Teacher
    @State private var showingAlert = false
    @State private var isLogoutLoading = false

    var body: some View {
        ZStack {
            VStack {
                Text("Hola Negro")
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
                                    sectionTitle: "Agendar",
                                    sectionDescription: "Agendar uma nova sessão para uma data futura",
                                    isUnavailable: false,
                                    sectionAction: {
                    })
                    MainMenuSection(sectionColor: .green,
                                    sectionIcon: MainMenuIcons.calendarIcon,
                                    sectionTitle: "Agendamentos",
                                    sectionDescription: "Visualizar sessões futuras e os seus participantes",
                                    isUnavailable: false,
                                    sectionAction: {
                        })
                }
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .yellow,
                                    sectionIcon: "clock.arrow.circlepath",
                                    sectionTitle: "Histórico",
                                    sectionDescription: "Visualizar sessões e participantes das sessões passadas",
                                    isUnavailable: false,
                                    sectionAction: {
                    })
                    MainMenuSection(sectionColor: .blue,
                                    sectionIcon: MainMenuIcons.logoutIcon,
                                    sectionTitle: "Logout",
                                    sectionDescription: "Sair para o menu principal",
                                    isUnavailable: false,
                                    sectionAction: {
                        showingAlert = true 
                    })
                }
            }
            
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
            
        }
        .navigationBarBackButtonHidden()
    }
    
    func beginLogoutAnimation() {
        showingAlert = false
        isLogoutLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            logout()
        }
    }
    
    func logout() {
        presentationMode.wrappedValue.dismiss()
    }
}
