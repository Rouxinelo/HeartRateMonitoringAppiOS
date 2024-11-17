//
//  TeacherSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 15/11/2024.
//

import SwiftUI

struct TeacherSessionScreen: View {
    @StateObject var viewModel = TeacherSessionViewModel()
    @State var sessionStartedData: TeacherSessionStartedData
    @State var testItems = [TeacherSessionUserData]()
    
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
                        Text("00h00m00s")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        HStack (spacing: 0) {
                            Text("10")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "person.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                        }
                    }
                }
                VStack (spacing: 0) {
                    ForEach(testItems, id: \.self) { userData in
                        TeacherSessionUserView(isActive: userData.isActive,
                                               name: "\(userData.name)",
                                               measurements: userData.measurements)
                            .padding(.vertical)
                    }
                }.scrollOnOverflow()
                Spacer()
            }.padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
}

