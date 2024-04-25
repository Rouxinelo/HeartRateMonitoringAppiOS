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
    @State private var firstLoad = true
    @State var showJoinableSessionsModal: Bool = false
    @State var showSignedSessionsModal: Bool = false
    @State var showPreviousSessionsModal: Bool = false
    @State var showSignedOutToast: Bool = false
    @State var showComingSoonToast: Bool = false
    @State var joinableSessions = [Session]()
    @State var signedSessions = [Session]()
    @State var previousSessions = [Session]()
    @State var user: User
    
    var body: some View {
        ZStack {
            VStack {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text("Available Sessions")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                
                Image("heart-rate").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100)
                
                MultipleTextButton(action: { showJoinableSessionsModal = true },
                                   title: "Ready to join",
                                   description: "You can join one of this sessions now")
                .padding()
                
                MultipleTextButton(action: { showSignedSessionsModal = true },
                                   title: "Signed sessions",
                                   description: "View future sessions and cancel if needed")
                .padding()
                
                MultipleTextButton(action: { showPreviousSessionsModal = true },
                                   title: "Previously Joined",
                                   description: "View statistics about previous sessions")
                .padding()
                
                Spacer()
            }
            
            if showSignedSessionsModal {
                UserSessionsModal(isShowing: $showSignedSessionsModal,
                                  sessions: signedSessions,
                                  title: "Signed Sessions",
                                  modalType: .signOut,
                                  onSelectSession: { session in
                    handleSessionSignOut(session)
                })
            }
            
            if showJoinableSessionsModal {
                UserSessionsModal(isShowing: $showJoinableSessionsModal,
                                  sessions: joinableSessions,
                                  title: "Joinable Sessions",
                                  onSelectSession: { session in
                    handleSessionJoin(session)
                })
            }
            
            if showPreviousSessionsModal {
                UserSessionsModal(isShowing: $showPreviousSessionsModal,
                                  sessions: previousSessions,
                                  title: "Previous Sessions",
                                  onSelectSession: { session in
                    handlePreviousSession(session)
                })
            }
            
            if showSignedOutToast {
                CustomToast(isShowing: $showSignedOutToast,
                            iconName: "info.circle.fill",
                            message: "Signed out successfully")
            }
            
            if showComingSoonToast {
                CustomToast(isShowing: $showComingSoonToast,
                            iconName: "info.circle.fill",
                            message: "Coming Soon")
            }
        }
        .onAppear {
            if firstLoad {
                firstLoad.toggle()
                setSignedSessions()
                setJoinableSessions()
                setPreviousSessions()
            }
        }
        .navigationDestination(for: PreSessionData.self, destination: { preSessionData in
            JoinSessionScreen(path: $path, preSessionData: preSessionData)
        })
        .navigationBarBackButtonHidden()
    }
    
    func setJoinableSessions() {
        joinableSessions = [Session(id: "test1",
                                    name: "testname1",
                                    date: "22/22",
                                    hour: "22h",
                                    teacher: "Test T",
                                    totalSpots: 11,
                                    filledSpots: 11)]
    }
    
    func setSignedSessions() {
        signedSessions = [Session(id: "test1",
                                  name: "testname1",
                                  date: "22/22",
                                  hour: "22h",
                                  teacher: "Test T",
                                  totalSpots: 11,
                                  filledSpots: 11,
                                  description: "this is just a test description")]
    }
    
    func setPreviousSessions() {
        previousSessions = [Session(id: "previous1",
                                  name: "testname1",
                                  date: "22/22",
                                  hour: "22h",
                                  teacher: "Test T",
                                  totalSpots: 11,
                                  filledSpots: 11,
                                  description: "this is just a test description")]
    }
    
    func handleSessionSignOut(_ session: Session) {
        guard let sessionIndex = signedSessions.firstIndex(of: session) else { return }
        signedSessions.remove(at: sessionIndex)
        showSignedOutToast = true
    }
    
    func handleSessionJoin(_ session: Session) {
        path.append(PreSessionData(session: session,
                                   user: user))
    }
    
    func handlePreviousSession(_ session: Session) {
        showComingSoonToast = true
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
