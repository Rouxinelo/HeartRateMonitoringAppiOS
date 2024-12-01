//
//  TeacherSessionSummaryScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/11/2024.
//

import SwiftUI

struct TeacherSessionSummaryScreen: View {
    @State var teacherSessionSummaryData: TeacherSessionSummaryData
    @StateObject var viewModel = TeacherSessionSummaryViewModel()
    @State var showingCloseAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack (spacing: 25) {
                HStack (alignment: .center) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundStyle(.red)
                        Text(teacherSessionSummaryData.sessionName)
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
                        Text(teacherSessionSummaryData.sessionTime)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        HStack (spacing: 0) {
                            Text("\(teacherSessionSummaryData.sessionUserData.count)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "person.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                        }
                    }
                }
                VStack {
                    HStack {
                        Text("Summary:")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text("(Users without any heartrate measurements were excluded)")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                List(viewModel.userSummaryData, id: \.self) { userData in
                    TeacherSessionSummaryUserView(user: userData.user,
                                                  measurements: userData.measurements)
                    .padding(.vertical)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .edgesIgnoringSafeArea(.all)
                .listStyle(PlainListStyle())
                
                Spacer()
                
            }.padding(.horizontal)
            
            if showingCloseAlert {
                CustomAlert(isShowing: $showingCloseAlert,
                            icon: "exclamationmark.circle",
                            title: localized(TeacherSessionStrings.alertTitleString),
                            leftButtonText: localized(TeacherSessionStrings.alertLeftButtonString),
                            rightButtonText: localized(TeacherSessionStrings.alertRightButtonString),
                            description: localized(TeacherSessionStrings.alertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: {},
                            isSingleButton: false)
            }
            
        }
        .onAppear {
            viewModel.getUserSummaryData(for: teacherSessionSummaryData)
        }
        .navigationBarBackButtonHidden()
    }
    
    func didTapClose() {
        showingCloseAlert = true
    }
}
