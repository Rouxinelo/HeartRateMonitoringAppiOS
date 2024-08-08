//
//  InsertRecoveryCodeScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 04/08/2024.
//

import SwiftUI

struct Constants {
    static let passwordMinimumLength: Int = 8
    static let codeLength: Int = 5
}

struct InsertRecoveryCodeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var isLoadingActive: Bool = false
    @State var showingErrorAlert: Bool = false
    @State var showingSuccessAlert: Bool = false
    @State var showNetworkErrorAlert: Bool = false
    @State var recoveryCode: RecoveryCode
    @State var codeString: String = ""
    @State var passwordString: String = ""
    @State var confirmPasswordString: String = ""
    @StateObject var viewModel = InsertRecoveryCodeViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(InsertRecoveryCodeStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding()
                
                Image("heart-rate")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                VStack(spacing: 5) {
                    
                    HStack {
                        Text(localized(InsertRecoveryCodeStrings.codeTitleString))
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(spacing: 10) {
                            CustomNumericField(numberText: $codeString,
                                               placeHolder: localized(InsertRecoveryCodeStrings.codePlaceHolderString),
                                               maximumDigits: 5)
                            .frame(width: 150)
                            
                            if codeString.count == Constants.codeLength {
                                HStack {
                                    Image(systemName: isCodeValid() ? "checkmark.circle.fill" : "x.circle.fill")
                                    Text(localized(getCodeString()))
                                }
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(isCodeCorrect() ? .green : .red)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Text(localized(InsertRecoveryCodeStrings.codeDescriptionString).replacingOccurrences(of: "$", with: recoveryCode.user.username))
                        .foregroundStyle(.gray)
                        .padding(.horizontal)

                    HStack {
                        Text(localized(InsertRecoveryCodeStrings.newPasswordString))
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    CustomTextField(searchText: $passwordString,
                                    isPrivateField: false,
                                    placeholder: localized(InsertRecoveryCodeStrings.insertPasswordString))
                    .padding()
                    
                    CustomTextField(searchText: $confirmPasswordString,
                                    isPrivateField: false,
                                    placeholder: localized(InsertRecoveryCodeStrings.confirmPasswordString))
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        changePassword()
                    }, label: {
                        Text(localized(InsertRecoveryCodeStrings.recoverPasswordButtonString))
                            .padding()
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .background(canEnableRecoverButton() ? .red : .gray)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .disabled(!canEnableRecoverButton())
                    })
                    .padding()
                }
            }
            
            if isLoadingActive {
                LoadingView(isShowing: $isLoadingActive,
                            title: localized(InsertRecoveryCodeStrings.loadingTitleString),
                            description: localized(InsertRecoveryCodeStrings.loadingDescriptionString))
            }
            
            if showingErrorAlert {
                CustomAlert(isShowing: $showingErrorAlert,
                            icon: "exclamationmark.circle",
                            title: localized(InsertRecoveryCodeStrings.errorTitleString),
                            leftButtonText: localized(InsertRecoveryCodeStrings.alertButtonString),
                            rightButtonText: "",
                            description: localized(InsertRecoveryCodeStrings.errorDescriptionString),
                            leftButtonAction: { leaveToMainScreen() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
            if showNetworkErrorAlert {
                CustomAlert(isShowing: $showingSuccessAlert,
                            icon: "exclamationmark.circle",
                            title: localized(InsertRecoveryCodeStrings.networkAlertTitleString),
                            leftButtonText: localized(InsertRecoveryCodeStrings.alertButtonString),
                            rightButtonText: "",
                            description: localized(InsertRecoveryCodeStrings.networkAlertDescriptionString),
                            leftButtonAction: { leaveToMainScreen() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
            if showingSuccessAlert {
                CustomAlert(isShowing: $showingSuccessAlert,
                            icon: "exclamationmark.circle",
                            title: localized(InsertRecoveryCodeStrings.sucessAlertTitleString),
                            leftButtonText: localized(InsertRecoveryCodeStrings.alertButtonString),
                            rightButtonText: "",
                            description: localized(InsertRecoveryCodeStrings.sucessAlertDescriptionString),
                            leftButtonAction: { leaveToMainScreen() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            
        }.onAppear {
            isLoadingActive = true
            viewModel.sendRecoveryEmail(RecoveryEmailData(username: recoveryCode.user.username,
                                                          code: recoveryCode.code,
                                                          languageCode: getCurrentLanguage()))
        }.onReceive(viewModel.publisher) { response in
            switch response {
            case .emailSentSuccessful:
                isLoadingActive = false
            case .passwordChangeSuccessful:
                isLoadingActive = false
                showingSuccessAlert = true
            case .emailSendFailed, .passwordChangeFailed:
                isLoadingActive = false
                showingErrorAlert = true
            case .error:
                isLoadingActive = false
                showNetworkErrorAlert = true
            }
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
              self.endTextEditing()
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func leaveToMainScreen() {
        path.removeLast(path.count)
    }
    
    func canEnableRecoverButton() -> Bool {
        isCodeValid() && areFieldsValid()
    }
    
    func changePassword() {
        isLoadingActive = true
        viewModel.changePassword(PasswordChangeData(username: recoveryCode.user.username, newPassword: passwordString))
    }
    
    func isCodeValid() -> Bool {
        codeString.count == Constants.codeLength && isCodeCorrect()
    }
    
    func isCodeCorrect() -> Bool {
        codeString == String(recoveryCode.code)
    }
    
    func areFieldsValid() -> Bool {
        passwordString.count >= Constants.passwordMinimumLength && confirmPasswordString.count >= Constants.passwordMinimumLength && passwordString == confirmPasswordString
    }
    
    func getCodeString() -> String {
        isCodeValid() ? localized(InsertRecoveryCodeStrings.validCodeString): localized(InsertRecoveryCodeStrings.invalidCodeString)
    }
}
