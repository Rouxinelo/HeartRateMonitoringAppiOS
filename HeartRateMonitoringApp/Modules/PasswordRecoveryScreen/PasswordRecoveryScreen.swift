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
                        Text(localized(PasswordRecoveryStrings.textFieldTitleString))
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    
                    CustomTextField(searchText: $username,
                                    isPrivateField: false,
                                    placeholder: "")
                    .padding()
                    
                    Text(PasswordRecoveryStrings.textFieldDescriptionString)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    isLoadingActive.toggle()
                    viewModel.searchForUser(username)
                }, label: {
                    Text(PasswordRecoveryStrings.recoverPasswordButtonString)
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
                            title: PasswordRecoveryStrings.loadingTitleString,
                            description: PasswordRecoveryStrings.loadingDescriptionString)
            }
            
            if showNoUserFoundAlert {
                CustomAlert(isShowing: $showNoUserFoundAlert,
                            icon: "exclamationmark.circle",
                            title: PasswordRecoveryStrings.alertTitleString,
                            leftButtonText: PasswordRecoveryStrings.alertButtonString,
                            rightButtonText: "",
                            description: PasswordRecoveryStrings.alertDescriptionString,
                            leftButtonAction: {},
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }.navigationBarBackButtonHidden()
            .navigationDestination(for: RecoveryCode.self, destination: { recoveryCode in
                
            })
            .onReceive(viewModel.publisher) { result in
                switch result {
                case .didFindUser(let username, let recoveryCode):
                    path.append(RecoveryCode(user: username, code: recoveryCode))
                case .didNotFindUser:
                    isLoadingActive = false
                    showNoUserFoundAlert.toggle()
                }
            }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}
