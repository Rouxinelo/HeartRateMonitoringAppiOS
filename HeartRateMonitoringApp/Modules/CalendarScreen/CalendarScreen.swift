//
//  CalendarScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct CalendarScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var searchText: String = ""
    @State var didSignIn: Bool = false
    @State var showEmptyAlert: Bool = false
    @State var isGuest: Bool
    @State var username: String?
    @State var sessions: [Session]
    @State var sessionToSignIn: Session?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(CalendarStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                CustomTextField(searchText: $searchText,
                                isPrivateField: false,
                                placeholder: localized(CalendarStrings.textFieldPlaceholder))
                .padding()
                
                HStack {
                    Text(localized(CalendarStrings.sessionsCount).replacingOccurrences(of: "$", with: "\(filterSessions(searchText).count)"))
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
                
                VStack (spacing: 0) {
                    ForEach(filterSessions(searchText), id: \.self) { session in
                        SessionSection(title: session.name,
                                        date: session.date,
                                        hour: session.hour,
                                        teacher: session.teacher,
                                        occupation: getOccupationString(totalSpots: session.totalSpots,
                                                                        occupiedSpots: session.filledSpots),
                                        onClick: { clickedSession(session) })
                    }
                }.scrollOnOverflow()
                    .padding(.top)
                
            }
            .padding()
            .navigationDestination(for: Session.self, destination: { session in
                SessionDetailScreen(didSignIn: $didSignIn, isGuest: isGuest, session: session, username: username)
            })
            .navigationBarBackButtonHidden()
            .onAppear {
                if didSignIn { removeSession() }
            }
            if didSignIn {
                CustomToast(isShowing: $didSignIn, iconName: "info.circle.fill", message: localized(CalendarStrings.toastMessage))
            }
            if sessions.isEmpty {
                CustomAlert(isShowing: $showEmptyAlert,
                            icon: "exclamationmark.circle",
                            title: localized(CalendarStrings.alertTitle),
                            leftButtonText: localized(CalendarStrings.alertLeftButton),
                            rightButtonText: "",
                            description: localized(CalendarStrings.alertDescription),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func getOccupationString(totalSpots: Int, occupiedSpots: Int) -> String {
        "\(occupiedSpots)/\(totalSpots)"
    }
    
    func clickedSession(_ session: Session) {
        sessionToSignIn = session
        path.append(session)
    }
    
    func removeSession() {
        guard let sessionToSignIn = sessionToSignIn,
                let index = sessions.firstIndex(where: {$0.id == sessionToSignIn.id}) else { return }
        sessions.remove(at: index)
        self.sessionToSignIn = nil
    }
    
    func filterSessions(_ searchText: String) -> [Session] {
        guard searchText.replacingOccurrences(of: " ", with: "") != "" else { return sessions }
        return sessions.filter { containsSearchedText($0, searchText)}
    }
    
    func containsSearchedText(_ session: Session, _ searchText: String) -> Bool {
        session.name.removeSpaces().lowercased().contains(searchText.removeSpaces().lowercased()) ||
        session.teacher.removeSpaces().lowercased().contains(searchText.removeSpaces().lowercased())
    }
}

#Preview {
    CalendarScreen(path: .constant(NavigationPath()),
                   didSignIn: false,
                   isGuest: true,
                   sessions: [Session(id: "test1", 
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
                                      filledSpots: 5)])
}
