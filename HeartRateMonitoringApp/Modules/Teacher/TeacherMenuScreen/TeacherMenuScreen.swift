//
//  TeacherMenuScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/08/2024.
//

import SwiftUI

enum TeacherMenuDestinations {
    case createSession(String)
    case previousSessions(String)
    case futureSessions(String)
}

struct TeacherMenuScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var teacher: Teacher
    @State private var showingAlert = false
    @State private var isLogoutLoading = false
    @State private var showSessionToast = false
    
    var body: some View {
        ZStack {
            VStack {
                Text(localized(TeacherMenuStrings.titleString).replacingOccurrences(of: "$", with: teacher.name))
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
                                    sectionTitle: localized(TeacherMenuStrings.createSessionTitleString),
                                    sectionDescription: localized(TeacherMenuStrings.createSessionDescriptionString),
                                    isUnavailable: false,
                                    sectionAction: {
                        path.append(CreateSessionData(teacherName: teacher.name))
                    })
                    MainMenuSection(sectionColor: .green,
                                    sectionIcon: MainMenuIcons.calendarIcon,
                                    sectionTitle: localized(TeacherMenuStrings.futureSessionsTitleString),
                                    sectionDescription: localized(TeacherMenuStrings.futureSessionsDescriptionString),
                                    isUnavailable: false,
                                    sectionAction: {
                        path.append(FutureSessionTeacherData(teacherName: teacher.name))
                    })
                }
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .yellow,
                                    sectionIcon: "door.left.hand.closed",
                                    sectionTitle: localized(TeacherMenuStrings.joinSessionTitleString),
                                    sectionDescription: localized(TeacherMenuStrings.joinSessionDescriptionString),
                                    isUnavailable: false,
                                    sectionAction: {
                        path.append(JoinableSessionTeacherData(teacherName: teacher.name))

                    })
                    MainMenuSection(sectionColor: .blue,
                                    sectionIcon: MainMenuIcons.logoutIcon,
                                    sectionTitle: localized(TeacherMenuStrings.logoutTitleString),
                                    sectionDescription: localized(TeacherMenuStrings.logoutDescriptionString),
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
            
            if showSessionToast {
                CustomToast(isShowing: $showSessionToast,
                            iconName: "info.circle.fill",
                            message: localized(TeacherMenuStrings.sessionToastString))
            }
            
        }
        .navigationDestination(for: CreateSessionData.self) { createSessionData in
            CreateSessionScreen(showCreateSessionToast: $showSessionToast, createSessionData: createSessionData)
        }
        .navigationDestination(for: FutureSessionTeacherData.self) { futureSessionData in
            FutureSessionsTeacherScreen(futureSessionData: futureSessionData)
        }
        .navigationDestination(for: JoinableSessionTeacherData.self) { joinableSessionData in
            TeacherJoinableSessionsScreen(path: $path, joinableSessionData: joinableSessionData)
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
