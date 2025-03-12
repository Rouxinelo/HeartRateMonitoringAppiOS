//
//  TeacherJoinableSessionsScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 10/10/2024.
//

import SwiftUI

struct TeacherJoinableSessionsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @StateObject var viewModel = TeacherJoinableSessionsViewModel()
    @State var joinableSessionData: JoinableSessionTeacherData
    @State var searchText: String = ""
    @State var sessions: [Session] = []
    @State var selectedSession: Session?
    @State var loadingSessionsAlert: Bool = false
    @State var loadingSessionStartAlert: Bool = false
    @State var showJoinSessionModal: Bool = false
    @State var showStartFailedAlert: Bool = false
    @State var showNoSessionsAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(TeacherJoinableSessionsStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                CustomTextField(searchText: $searchText,
                                isPrivateField: false,
                                placeholder: localized(TeacherJoinableSessionsStrings.searchPlaceholderString))
                .padding()
                
                HStack {
                    Text(localized(TeacherJoinableSessionsStrings.sessionsCountString).replacingOccurrences(of: "$", with: "\(filterSessions(searchText).count)"))
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
                
                Spacer()
            }
            .padding(.horizontal)
            
            if loadingSessionsAlert {
                LoadingView(isShowing: $loadingSessionsAlert,
                            title: localized(TeacherJoinableSessionsStrings.loadingTitleString),
                            description: localized(TeacherJoinableSessionsStrings.loadingDescriptionString))
            }
            
            if loadingSessionStartAlert {
                LoadingView(isShowing: $loadingSessionStartAlert,
                            title: localized(TeacherJoinableSessionsStrings.startLoadingTitleString),
                            description: localized(TeacherJoinableSessionsStrings.startLoadingDescriptionString))
            }
            
            if showJoinSessionModal, let selectedSession = selectedSession {
                SessionSetupView(isShowing: $showJoinSessionModal,
                                 session: selectedSession,
                                 onStartPressed: { zoomId, zoomPassword, session in
                    startSession(session: session, zoomId: zoomId, zoomPassword: zoomPassword)
                })
            }
            
            if showStartFailedAlert {
                CustomAlert(isShowing: $showStartFailedAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherJoinableSessionsStrings.startAlertTitleString),
                            leftButtonText: localized(TeacherJoinableSessionsStrings.startAlertButtonString),
                            rightButtonText: "",
                            description: localized(TeacherJoinableSessionsStrings.startAlertDescriptionString),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
            if showNoSessionsAlert {
                CustomAlert(isShowing: $showNoSessionsAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherJoinableSessionsStrings.noSessionsAlertTitleString),
                            leftButtonText: localized(TeacherJoinableSessionsStrings.noSessionsLeftButtonString),
                            rightButtonText: "",
                            description: localized(TeacherJoinableSessionsStrings.noSessionsDescriptionString),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadingSessionsAlert = true
            viewModel.loadSessions(joinableSessionData.teacherName)
        }.navigationBarBackButtonHidden()
        .navigationDestination(for: TeacherSessionStartedData.self, destination: { sessionStartedData in
            TeacherSessionScreen(path: $path, sessionStartedData: sessionStartedData)
        })
        .onReceive(viewModel.publisher) { response in
            switch response {
            case .noSessionsLoaded:
                loadingSessionsAlert = false
                showNoSessionsAlert = true
            case .sessionsLoaded(let sessions):
                self.sessions = sessions
                loadingSessionsAlert = false
            case .sessionStartFailed:
                loadingSessionStartAlert = false
                showStartFailedAlert = true
            case .sessionStartSuccessful:
                loadingSessionStartAlert = false
                goToSessionScreen()
            }
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func filterSessions(_ searchText: String) -> [Session] {
        guard searchText.replacingOccurrences(of: " ", with: "") != "" else { return sessions }
        return sessions.filter { containsSearchedText($0, searchText)}
    }
    
    func containsSearchedText(_ session: Session, _ searchText: String) -> Bool {
        session.name.removeSpaces().lowercased().contains(searchText.removeSpaces().lowercased())
    }
    
    func clickedSession(_ session: Session) {
        selectedSession = session
        showJoinSessionModal = true
    }
    
    func startSession(session: Session, zoomId: String, zoomPassword: String) {
        loadingSessionStartAlert = true
        viewModel.startSession(sessionId: session.id, zoomId: zoomId, zoomPassword: zoomPassword)
    }
    
    func getOccupationString(totalSpots: Int, occupiedSpots: Int) -> String {
        "\(occupiedSpots)/\(totalSpots)"
    }
    
    func goToSessionScreen() {
        guard let selectedSession = selectedSession else { return }
        path.append(TeacherSessionStartedData(teacher: joinableSessionData.teacherName, sessionId: selectedSession.id, sessionName: selectedSession.name))
    }
}
