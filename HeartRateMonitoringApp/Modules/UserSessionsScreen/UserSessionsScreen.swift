//
//  UserSessionsScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 06/04/2024.
//

import SwiftUI

struct UserSessionsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var showJoinableSessionsModal: Bool = false
    @State var showSignedSessionsModal: Bool = false
    @State var showPreviousSessionsModal: Bool = false
    @State var showSignedOutToast: Bool = false
    @State var showFailedSignOutToast: Bool = false
    @State var showErrorSessionAlert: Bool = false
    @State var showLoading: Bool = false
    @State var joinableSessions = [Session]()
    @State var signedSessions = [Session]()
    @State var previousSessions = [Session]()
    @State var user: User
    @StateObject var viewModel = UserSessionsViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(UserSessionsStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                
                Image("heart-rate").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100)
                
                MultipleTextButton(action: { searchSessions(.joinable) },
                                   title: localized(UserSessionsStrings.readyToJoinTitleString),
                                   description: localized(UserSessionsStrings.signedSessionsDescriptionString))
                .padding()
                
                MultipleTextButton(action: { searchSessions(.signed) },
                                   title: localized(UserSessionsStrings.signedSessionsTitleString),
                                   description: localized(UserSessionsStrings.signedSessionsDescriptionString))
                .padding()
                
                MultipleTextButton(action: { searchSessions(.previous) },
                                   title: localized(UserSessionsStrings.previousSessionsTitleString),
                                   description: localized(UserSessionsStrings.previousSessionsDescriptionString))
                .padding()
                Spacer()
            }
            
            if showSignedSessionsModal {
                UserSessionsModal(isShowing: $showSignedSessionsModal,
                                  sessions: signedSessions,
                                  title: localized(UserSessionsStrings.signedModalString),
                                  modalType: .signOut,
                                  onSelectSession: { session in
                    signOutSession(for: session.id)
                })
            }
            
            if showJoinableSessionsModal {
                UserSessionsModal(isShowing: $showJoinableSessionsModal,
                                  sessions: joinableSessions,
                                  title: localized(UserSessionsStrings.joinableModalString),
                                  onSelectSession: { session in
                    handleSessionJoin(session)
                })
            }
            
            if showPreviousSessionsModal {
                UserSessionsModal(isShowing: $showPreviousSessionsModal,
                                  sessions: previousSessions,
                                  title: localized(UserSessionsStrings.previousModalString),
                                  onSelectSession: { session in
                    fetchPreviousSession(session)
                })
            }
            
            if showSignedOutToast {
                CustomToast(isShowing: $showSignedOutToast,
                            iconName: "info.circle.fill",
                            message: localized(UserSessionsStrings.signedToastString))
            }
            
            if showFailedSignOutToast {
                CustomToast(isShowing: $showFailedSignOutToast,
                            iconName: "info.circle.fill",
                            message: localized(UserSessionsStrings.signedToastFailString))
            }
            
            if showLoading {
                LoadingView(isShowing: $showLoading,
                            title: localized(UserSessionsStrings.loadingTitleString),
                            description: localized(UserSessionsStrings.loadingDescriptionString))
            }
            
            if showErrorSessionAlert {
                CustomAlert(isShowing: $showErrorSessionAlert,
                            icon: "exclamationmark.circle",
                            title: localized(UserSessionsStrings.alertTitleString),
                            leftButtonText: localized(UserSessionsStrings.alertButtonString),
                            rightButtonText: "",
                            description: localized(UserSessionsStrings.alertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }.swipeRight {
            back()
        }
        .navigationDestination(for: PreSessionData.self, destination: { preSessionData in
            JoinSessionScreen(path: $path, preSessionData: preSessionData)
        })
        .navigationDestination(for: PreviousSessionData.self, destination: { previousSessionData in
            PreviousSessionScreen(sessionData: previousSessionData)
        })
        .onReceive(viewModel.publisher) { recieveValue in
            handlePublisherResponse(recieveValue)
        }
        .navigationBarBackButtonHidden()
    }
    
    func handlePublisherResponse(_ response: UserSessionPublisherCases) {
        showLoading = false
        switch response {
        case .didLoadJoinableSessions(let sessions):
            setJoinableSessions(sessions ?? [])
        case .didLoadSignedSessions(let sessions):
            setSignedSessions(sessions ?? [])
        case .didLoadPreviousSessions(let sessions):
            setPreviousSessions(sessions ?? [])
        case .didFailSignOut:
            handleSessionSignOut(false)
        case .didSignOut:
            handleSessionSignOut(true)
        case .didLoadPreviousSession(let session):
            guard let session = session else {
                showErrorSessionAlert = true
                return
            }
            handlePreviousSession(session)
        }
    }
    
    func searchSessions(_ type: UserSessionType) {
        showLoading = true
        viewModel.fetchSessions(for: user.username, type)
    }
    
    func signOutSession(for sessionId: String) {
        showLoading = true
        viewModel.signOutSession(for: user.username, sessionId: sessionId)
    }
    
    func setJoinableSessions(_ sessions: [Session] = []) {
        joinableSessions = sessions
        showJoinableSessionsModal = true
    }
    
    func setSignedSessions(_ sessions: [Session] = []) {
        signedSessions = sessions
        showSignedSessionsModal = true
    }
    
    func setPreviousSessions(_ sessions: [Session] = []) {
        previousSessions = sessions
        showPreviousSessionsModal = true
    }
    
    func handleSessionSignOut(_ success: Bool) {
        if success {
            showSignedOutToast = true
        } else {
            showFailedSignOutToast = true
        }
    }
    
    func handleSessionJoin(_ session: Session) {
        path.append(PreSessionData(session: session,
                                   user: user))
    }
    
    func fetchPreviousSession(_ session: Session) {
        showLoading = true
        viewModel.fetchPreviousSession(for: user.username, sessionId: session.id)
    }
    
    func handlePreviousSession(_ previousSessionData: PreviousSessionData) {
        path.append(previousSessionData)
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    UserSessionsScreen(path: .constant(NavigationPath()),
                       user: User(username: "",
                                  firstName: "",
                                  lastName: "",
                                  email: "",
                                  gender: "",
                                  age: 0,
                                  password: ""))
}
