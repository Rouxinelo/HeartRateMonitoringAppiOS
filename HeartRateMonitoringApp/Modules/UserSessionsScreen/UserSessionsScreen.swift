//
//  UserSessionsScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 06/04/2024.
//

import SwiftUI

struct UserSessionsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var showJoinableSessionsModal: Bool = false
    @State var showSignedSessionsModal: Bool = false
    @State var joinableSessions = [Session]()
    @State var signedSessions: [Session] = []
    @State var user: User
    
    var body: some View {
        ZStack {
            VStack(spacing: 100) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text("Available Sessions")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                Button(action: {
                    showJoinableSessionsModal = true
                }) {
                    HStack {
                        VStack(spacing: 5) {
                            Text("Ready to join")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading).padding(.leading)
                            Text("You can join one of this sessions now")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading).padding(.leading)
                        }
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.red)
                            .padding()
                    }
                }.foregroundStyle(.black)
                Button(action: {
                    showSignedSessionsModal = true
                }) {
                    HStack {
                        VStack(spacing: 5) {
                            Text("Signed sessions")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            Text("View future sessions and cancel if needed")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                        }
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.red)
                            .padding()
                    }
                }.foregroundStyle(.black)
                Spacer()
            }
            if showSignedSessionsModal {
                UserSessionsModal(isShowing: $showSignedSessionsModal,
                                  sessions: signedSessions,
                                  title: "Signed Sessions",
                                  onSelectSession: { _ in })
            }
            if showJoinableSessionsModal {
                UserSessionsModal(isShowing: $showJoinableSessionsModal,
                                  sessions: joinableSessions,
                                  title: "Joinable Sessions",
                                  onSelectSession: { _ in })
            }
        }
        .onAppear {
            setSignedSessions()
            setJoinableSessions()
        }
        .navigationBarBackButtonHidden()
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
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
                                  filledSpots: 11)]
    }
}

#Preview {
    UserSessionsScreen(user: User(username: "",
                                  firstName: "",
                                  lastName: "",
                                  email: "",
                                  gender: "",
                                  age: 0,
                                  password: ""))
}
