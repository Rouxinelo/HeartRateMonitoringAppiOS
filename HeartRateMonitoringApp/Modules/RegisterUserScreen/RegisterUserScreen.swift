//
//  RegisterUserScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct RegisterUserScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var userName: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var age: String = ""
    @State var isMaleSelected: Bool = false
    @State var isFemaleSelected: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
                
                VStack (spacing: 5) {
                    RegisterScreenField(searchText: $userName,
                                        isHiddenField: false,
                                        placeholder: "",
                                        title: "Username",
                                        description: "Used to login")
                    HStack {
                        RegisterScreenField(searchText: $firstName,
                                            isHiddenField: false,
                                            placeholder: "",
                                            title: "First Name",
                                            description: "Your first name")
                        RegisterScreenField(searchText: $lastName,
                                            isHiddenField: false,
                                            placeholder: "",
                                            title: "Last Name",
                                            description: "Your last name")
                    }
                    RegisterScreenField(searchText: $email,
                                        isHiddenField: false,
                                        placeholder: "",
                                        title: "Email",
                                        description: "Your email")
                    RegisterScreenField(searchText: $password,
                                        isHiddenField: true,
                                        placeholder: "",
                                        title: "Password",
                                        description: "Your password (minimum 6 characters)")
                    
                    HStack (spacing: 20){
                        VStack(spacing: 0) {
                            HStack {
                                Text("Age")
                                    .font(.headline).fontWeight(.bold)
                                Spacer()
                            }
                            CustomNumericField(numberText: $age, placeHolder: "")
                            HStack {
                                Text("Your age")
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("Gender")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            RegisterScreenGenderField(isMaleSelected: $isMaleSelected, isFemaleSelected: $isFemaleSelected)
                            HStack {
                                Text("Your gender")
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }.padding(.horizontal)
                    
                    Button(action: {
                    }) {
                        Text(LoginViewStrings.loginString)
                            .padding()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(false)
                }.scrollOnOverflow()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    RegisterUserScreen()
}
