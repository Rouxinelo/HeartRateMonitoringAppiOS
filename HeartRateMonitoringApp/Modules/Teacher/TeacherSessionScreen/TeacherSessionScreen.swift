//
//  TeacherSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 15/11/2024.
//

import SwiftUI

struct TeacherSessionScreen: View {
    @Binding var path: NavigationPath
    @StateObject var viewModel = TeacherSessionViewModel()
    @State var sessionStartedData: TeacherSessionStartedData
    @State var showUserEnterToast: Bool = false
    @State private var showingCloseAlert: Bool = false
    @State var toastMessage: String = ""
    
    var body: some View {
        ZStack {
            VStack (spacing: 25) {
                HStack (alignment: .center) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundStyle(.red)
                        Text(sessionStartedData.sessionName)
                    }
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        didTapClose()
                    }) {
                        VStack {
                            Image(systemName: "xmark")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.title2)
                            Text(localized(SessionStrings.closeString))
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                                .font(.headline)
                        }
                    }
                }
                VStack (spacing: 0) {
                    Text(localized(SessionStrings.timeString))
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(viewModel.sessionTimeString)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        HStack (spacing: 0) {
                            Text("\(viewModel.sessionUserData.count)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "person.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                List(viewModel.sessionUserData, id: \.self) { userData in
                    TeacherSessionUserView(isActive: userData.isActive,
                                           name: "\(userData.name)",
                                           measurements: userData.measurements)
                    .padding(.vertical)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
                
            }.padding(.horizontal)
            
            if showUserEnterToast {
                CustomToast(isShowing: $showUserEnterToast,
                            iconName: "info.circle.fill",
                            message: toastMessage)
            }
            
            if showingCloseAlert {
                CustomAlert(isShowing: $showingCloseAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherSessionStrings.alertTitleString),
                            leftButtonText: localized(TeacherSessionStrings.alertLeftButtonString),
                            rightButtonText: localized(TeacherSessionStrings.alertRightButtonString),
                            description: localized(TeacherSessionStrings.alertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: { viewModel.finishSession(sessionName: sessionStartedData.sessionName, sessionId: sessionStartedData.sessionId) },
                            isSingleButton: false)
            }
            
        }
        .onAppear {
            viewModel.startListening(sessionId: sessionStartedData.sessionId)
            viewModel.startTimer()
        }.onReceive(viewModel.publisher) { response in
            switch response {
            case .didEnterSession(let name):
                showToastMessage(event: .enterSession, name: name)
            case .didLeaveSession(let name):
                showToastMessage(event: .leaveSession, name: name)
            case .networkError:
                viewModel.finishSession(sessionName: sessionStartedData.sessionName, sessionId: sessionStartedData.sessionId)
            case .didCreateSummaryData(let summaryData):
                finishSession(with: summaryData)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(for: TeacherSessionSummaryData.self, destination: { summaryData in
            TeacherSessionSummaryScreen(path: $path, teacherSessionSummaryData: summaryData)
        })
    }
    
    func showToastMessage(event: SessionEvent, name: String) {
        switch event {
        case .enterSession:
            toastMessage = localized(TeacherSessionStrings.toastJoinString).replacingOccurrences(of: "$", with: name)
        case .leaveSession:
            toastMessage = localized(TeacherSessionStrings.toastLeaveString).replacingOccurrences(of: "$", with: name)
        }
        showUserEnterToast = false
        showUserEnterToast = true
    }
    
    func didTapClose() {
        showingCloseAlert = true
    }
    
    func finishSession(with summaryData: TeacherSessionSummaryData) {
        viewModel.stopTimer()
        viewModel.stopListening()
        path.append(summaryData)
    }
}

