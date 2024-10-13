//
//  TeacherJoinableSessionsScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 10/10/2024.
//

import SwiftUI

struct TeacherJoinableSessionsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = TeacherJoinableSessionsViewModel()
    @State var joinableSessionData: JoinableSessionTeacherData
    @State var searchText: String = ""
    @State var sessions: [Session] = []
    @State var selectedSession: Session?
    @State var loadingSessionsAlert: Bool = false
    @State var loadingSessionStartAlert: Bool = false
    @State var showJoinSessionModal: Bool = false
    @State var showJoinFailedAlert: Bool = false
    @State var showNoSessionsAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(TeacherFutureSessionsStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                CustomTextField(searchText: $searchText,
                                isPrivateField: false,
                                placeholder: localized(TeacherJoinableSessionsStrings.searchPlaceholderString))
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
                
                Spacer()
            }
            .padding(.horizontal)
            
            if loadingSessionsAlert {
                LoadingView(isShowing: $loadingSessionsAlert,
                            title: localized(TeacherFutureSessionsStrings.loadingTitleString),
                            description: localized(TeacherFutureSessionsStrings.loadingDescriptionString))
            }
            
            if loadingSessionStartAlert {
                LoadingView(isShowing: $loadingSessionStartAlert,
                            title: "Setting up", description: "Please wait...")
            }
            
            if showJoinSessionModal, let selectedSession = selectedSession {
                SessionSetupView(isShowing: $showJoinSessionModal,
                                 session: selectedSession,
                                 onStartPressed: { zoomId, zoomPassword, session in
                    startSession(session: session, zoomId: zoomId, zoomPassword: zoomPassword)
                })
            }
            
            if showJoinFailedAlert {
                CustomAlert(isShowing: $showJoinFailedAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherFutureSessionsStrings.failedAlertTitleString),
                            leftButtonText: localized(TeacherFutureSessionsStrings.failedAlertLeftButtonString),
                            rightButtonText: "",
                            description: localized(TeacherFutureSessionsStrings.failedAlertDescriptionString),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
            if showNoSessionsAlert {
                CustomAlert(isShowing: $showNoSessionsAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherFutureSessionsStrings.noSessionsAlertTitleString),
                            leftButtonText: localized(TeacherFutureSessionsStrings.noSessionsLeftButtonString),
                            rightButtonText: "",
                            description: localized(TeacherFutureSessionsStrings.noSessionsDescriptionString),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadingSessionsAlert = true
            viewModel.loadSessions(joinableSessionData.teacherName)
        }
        .onReceive(viewModel.publisher) { response in
            switch response {
            case .noSessionsLoaded:
                loadingSessionsAlert = false
                break
            case .sessionsLoaded(let sessions):
                self.sessions = sessions
                loadingSessionsAlert = false
            default:
                return
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
        session.name.removeSpaces().lowercased().contains(searchText.removeSpaces().lowercased()) ||
        session.teacher.removeSpaces().lowercased().contains(searchText.removeSpaces().lowercased())
    }
    
    func clickedSession(_ session: Session) {
        selectedSession = session
        showJoinSessionModal = true
    }
    
    func startSession(session: Session, zoomId: String, zoomPassword: String) {
        loadingSessionStartAlert = true
        // Send email to other users
        // Send request to join
    }
    
    func getOccupationString(totalSpots: Int, occupiedSpots: Int) -> String {
        "\(occupiedSpots)/\(totalSpots)"
    }
}
