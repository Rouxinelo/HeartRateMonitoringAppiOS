//
//  FutureSessionsTeacherScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 21/08/2024.
//

import SwiftUI

struct FutureSessionsTeacherScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = FutureSessionsTeacherViewModel()
    @State var futureSessionData: FutureSessionTeacherData
    @State var searchText: String = ""
    @State var sessions: [Session] = []
    @State var selectedSession: Session?
    @State var loadingSessionsAlert: Bool = false
    @State var showCancelAlert: Bool = false
    @State var showCancelFailedAlert: Bool = false
    @State var showCancelToast: Bool = false
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
                                placeholder: localized(TeacherFutureSessionsStrings.searchPlaceholderString))
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
            
            if showCancelAlert {
                CustomAlert(isShowing: $showCancelAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherFutureSessionsStrings.cancelAlertTitleString),
                            leftButtonText: localized(TeacherFutureSessionsStrings.cancelAlertLeftButtonString),
                            rightButtonText: localized(TeacherFutureSessionsStrings.cancelAlertRightButtonString),
                            description: localized(TeacherFutureSessionsStrings.cancelAlertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: { cancelSession() },
                            isSingleButton: false)
            }
            
            if showCancelFailedAlert {
                CustomAlert(isShowing: $showCancelFailedAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherFutureSessionsStrings.failedAlertTitleString),
                            leftButtonText: localized(TeacherFutureSessionsStrings.failedAlertLeftButtonString),
                            rightButtonText: "",
                            description: localized(TeacherFutureSessionsStrings.failedAlertDescriptionString),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
            if showCancelToast {
                CustomToast(isShowing: $showCancelToast,
                            iconName: "info.circle.fill",
                            message: localized(TeacherFutureSessionsStrings.toastTitleString))
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
            viewModel.loadSessions(futureSessionData.teacherName)
        }
        .onReceive(viewModel.publisher) { response in
            switch response {
            case .noSessionsLoaded:
                loadingSessionsAlert = false
                break
            case .sessionsLoaded(let sessions):
                self.sessions = sessions
                loadingSessionsAlert = false
            case .sessionCancelSuccessful:
                sessionCanceled()
            case .sessionCancelFailed:
                loadingSessionsAlert = false
                showCancelFailedAlert = true
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
        showCancelAlert = true
    }
    
    func cancelSession() {
        guard let selectedSession = selectedSession else {
            showCancelFailedAlert = true
            return
        }
        loadingSessionsAlert = true
        viewModel.cancelSession(teacher: futureSessionData.teacherName,
                                sessionId: selectedSession.id)
    }
    
    func sessionCanceled() {
        guard let selectedSession = selectedSession else { return }
        loadingSessionsAlert = false
        showCancelToast = true
        for (index, session) in sessions.enumerated() {
            if session == selectedSession {
                sessions.remove(at: index)
                return
            }
        }
    }
    
    func getOccupationString(totalSpots: Int, occupiedSpots: Int) -> String {
        "\(occupiedSpots)/\(totalSpots)"
    }
}
