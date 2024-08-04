//
//  PasswordRecoveryScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 04/08/2024.
//

import SwiftUI

struct PasswordRecoveryScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var username: String = ""
    @State var showNoUserFoundAlert: Bool = false
    @State var isLoadingActive: Bool = false
    @StateObject var viewModel = PasswordRecoveryViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(PasswordRecoveryStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                
                Image("heart-rate")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)

                VStack(spacing: 0) {
                    HStack {
                        Text("Enter your username")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    
                    CustomTextField(searchText: $username,
                                    isPrivateField: false,
                                    placeholder: "")
                    .padding()
                    
                    Text("If a username is found, and email will be sent")
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    isLoadingActive.toggle()
                    viewModel.searchForUser("cjisdcjc")
                }, label: {
                    Text("Recover Password")
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(username.isEmpty ? .gray : .red)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                })
                .disabled(username.isEmpty)
                .padding()
            }
            
            if isLoadingActive {
                LoadingView(isShowing: $isLoadingActive,
                            title: "Please wait",
                            description: "Searching for user...")
            }
            
            if showNoUserFoundAlert {
                CustomAlert(isShowing: $showNoUserFoundAlert,
                            icon: "exclamationmark.circle",
                            title: "Oops!",
                            leftButtonText: "Ok",
                            rightButtonText: "",
                            description: "No username found.",
                            leftButtonAction: {},
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }.navigationBarBackButtonHidden()
            .onReceive(viewModel.publisher) { result in
                switch result {
                case .didFindUser:
                    path.append(RecoveryCode(username: username, code: viewModel.generateRecoveryCode()))
                case .didNotFindUser:
                    showNoUserFoundAlert.toggle()
                }
            }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}
