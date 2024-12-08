//
//  TeacherSessionSummaryScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/11/2024.
//

import SwiftUI

struct TeacherSessionSummaryScreen: View {
    @Binding var path: NavigationPath
    @State var teacherSessionSummaryData: TeacherSessionSummaryData
    @StateObject var viewModel = TeacherSessionSummaryViewModel()
    @State var showBPMAlert: Bool = false
    @State var selectedUserAge: Int = 0
    
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
                        didPressClose()
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
                        Text(localized(TeacherSessionSummaryStrings.titleString))
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text(localized(TeacherSessionSummaryStrings.excludedUsersString))
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                List(viewModel.userSummaryData, id: \.self) { userData in
                    TeacherSessionSummaryUserView(user: userData.user,
                                                  measurements: userData.measurements, 
                                                  onClick: { user in
                        selectedUserAge = user.age
                        showBPMAlert = true
                    })
                    .padding(.vertical)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .edgesIgnoringSafeArea(.all)
                .listStyle(PlainListStyle())
                Spacer()
            }.padding(.horizontal)
            
            if showBPMAlert {
                TeacherSessionSummaryBPMView(isShowing: $showBPMAlert, age: selectedUserAge)
            }
        }
        .onAppear {
            viewModel.getUserSummaryData(for: teacherSessionSummaryData)
        }
        .navigationBarBackButtonHidden()
    }
    
    func didPressClose() {
        path.removeLast(path.count - 1)
    }
}
