//
//  RegisterUserScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct RegisterUserScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isNumericFieldFocused: Bool
    @Binding var showRegisterToast: Bool
    @State private var isLoading = false
    @State private var userName: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var birthDay: String = ""
    @State private var birthMonth: String = ""
    @State private var birthYear: String = ""
    @State private var isMaleSelected: Bool = false
    @State private var isFemaleSelected: Bool = false
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(RegisterUserStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
                
                VStack (spacing: 5) {
                    RegisterScreenField(searchText: $userName,
                                        isHiddenField: false,
                                        placeholder: "",
                                        title: localized(RegisterUserStrings.usernameString),
                                        description: localized(RegisterUserStrings.usernameDescription))
                    HStack {
                        RegisterScreenField(searchText: $firstName,
                                            isHiddenField: false,
                                            placeholder: "",
                                            title: localized(RegisterUserStrings.firstNameString),
                                            description: localized(RegisterUserStrings.firstNameDescription))
                        RegisterScreenField(searchText: $lastName,
                                            isHiddenField: false,
                                            placeholder: "",
                                            title: localized(RegisterUserStrings.lastNameString),
                                            description: localized(RegisterUserStrings.lastNameDescription))
                    }
                    RegisterScreenField(searchText: $email,
                                        isHiddenField: false,
                                        placeholder: "",
                                        title: localized(RegisterUserStrings.emailString),
                                        description: localized(RegisterUserStrings.emailDescription))
                    RegisterScreenField(searchText: $password,
                                        isHiddenField: true,
                                        placeholder: "",
                                        title: localized(RegisterUserStrings.passwordString),
                                        description: localized(RegisterUserStrings.passwordDescription))
                    .focused($isNumericFieldFocused)
                    
                    HStack {
                        Text(localized(RegisterUserStrings.dateTitleString))
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.horizontal)
                    HStack (spacing: 20){
                        VStack(spacing: 0) {
                            CustomNumericField(numberText: $birthDay, 
                                               placeHolder: "",
                                               maximumDigits: 2)
                                .focused($isNumericFieldFocused)
                            HStack {
                                Text(localized(RegisterUserStrings.dayString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                        VStack(spacing: 0) {
                            CustomNumericField(numberText: $birthMonth, 
                                               placeHolder: "",
                                               maximumDigits: 2)
                                .focused($isNumericFieldFocused)
                            HStack {
                                Text(localized(RegisterUserStrings.monthString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            
                        }
                        VStack(spacing: 0) {
                            CustomNumericField(numberText: $birthYear, 
                                               placeHolder: "",
                                               maximumDigits: 4)
                                .focused($isNumericFieldFocused)
                            HStack {
                                Text(localized(RegisterUserStrings.yearString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                    }.padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text(localized(RegisterUserStrings.genderString))
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        RegisterScreenGenderField(isMaleSelected: $isMaleSelected, isFemaleSelected: $isFemaleSelected)
                        HStack {
                            Text(localized(RegisterUserStrings.genderDescription))
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Button(action: {
                        register()
                    }) {
                        Text(localized(RegisterUserStrings.registerButton))
                            .padding()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(verifyFields() ? Color.red : Color.gray   )
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(!verifyFields())
                }.scrollOnOverflow()
            }
            .padding()
            
            if isLoading {
                LoadingView(isShowing: $isLoading,
                            title: localized(RegisterUserStrings.loadingViewTitle),
                            description: localized(RegisterUserStrings.loadingViewDescription))
            }
        }.swipeRight {
            back()
        }
        .navigationBarBackButtonHidden()
        .offset(y: isNumericFieldFocused ? -self.keyboardHeightHelper.keyboardHeight : 0)
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func verifyFields() -> Bool {
        return !userName.isEmpty && !email.isEmpty && selectedGender() && isValidPassword() && isValidDateOfBirth() && isValidUsername()
    }
    
    func isValidDateOfBirth() -> Bool {
        !birthDay.isEmpty && !birthMonth.isEmpty && !birthYear.isEmpty && birthDay.count == 2 && birthMonth.count == 2 && birthYear.count == 4
    }
    
    func isValidPassword() -> Bool {
        !password.isEmpty && password.count >= 6
    }
    
    func selectedGender() -> Bool {
        isMaleSelected || isFemaleSelected
    }
    
    func isValidUsername() -> Bool {
        !firstName.isEmpty && !lastName.isEmpty
    }
    
    func register() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            back()
            showRegisterToast = true
        }
    }
}

#Preview {
    RegisterUserScreen(showRegisterToast: .constant(false))
}
