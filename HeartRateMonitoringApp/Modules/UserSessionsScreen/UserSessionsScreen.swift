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
                    VStack(spacing: 5) {
                        Text("Ready to join")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                        Text("You can join one of this sessions now")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    }
                    VStack(spacing: 5) {
                        Text("Signed sessions")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        Text("View future sessions and cancel if needed")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    Spacer()
            }
        }
            .onAppear {
                setSignedSessions()
                setJoinableSessions()
            }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func setJoinableSessions() {
        joinableSessions = [Session(name: "testname1", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                            Session(name: "testname2", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                            Session(name: "testname3", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                            Session(name: "testname4", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                            Session(name: "testname5", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                            Session(name: "testname6", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
        ]
    }
    
    func setSignedSessions() {
        signedSessions = [Session(name: "testname1", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                          Session(name: "testname2", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                          Session(name: "testname3", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                          Session(name: "testname4", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                          Session(name: "testname5", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
                          Session(name: "testname6", date: "22/22", hour: "22h", teacher: "Test T", totalSpots: 11, filledSpots: 11),
        ]
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
