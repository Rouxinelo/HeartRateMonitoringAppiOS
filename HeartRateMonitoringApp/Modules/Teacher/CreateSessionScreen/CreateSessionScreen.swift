//
//  CreateSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/08/2024.
//

import SwiftUI

struct CreateSessionScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextFieldFocused: Bool
    @Binding var showCreateSessionToast: Bool
    @State private var sessionName: String = ""
    @State private var description: String = ""
    @State private var day: String = ""
    @State private var month: String = ""
    @State private var year: String = ""
    @State private var hour: Int = 0
    @State private var spots: String = ""
    @State private var isLoading: Bool = false
    @State private var showErrorAlert: Bool = false
    @StateObject var viewModel = CreateSessionViewModel()
    @State var createSessionData: CreateSessionData
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(CreateSessionStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
                
                VStack(spacing: 5) {
                    RegisterScreenField(searchText: $sessionName,
                                        isHiddenField: false,
                                        placeholder: localized(CreateSessionStrings.namePlaceholderString),
                                        title: localized(CreateSessionStrings.nameTitleString),
                                        description: localized(CreateSessionStrings.nameDescriptionString))
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text(localized(localized(CreateSessionStrings.descriptionTitleString)))
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        TextEditor(text: $description)
                            .padding()
                            .frame(height: 200)
                            .focused($isTextFieldFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isTextFieldFocused ? Color.red : Color.gray, lineWidth: 2)
                            )
                        HStack {
                            Text(localized(CreateSessionStrings.descriptionDescriptionString))
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text(localized(CreateSessionStrings.dateTitleString))
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack (spacing: 20){
                        VStack(spacing: 0) {
                            CustomNumericField(numberText: $day,
                                               placeHolder: "",
                                               maximumDigits: 2)
                            HStack {
                                Text(localized(CreateSessionStrings.dayString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                        VStack(spacing: 0) {
                            CustomNumericField(numberText: $month,
                                               placeHolder: "",
                                               maximumDigits: 2)
                            HStack {
                                Text(localized(CreateSessionStrings.monthString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                            
                        }
                        VStack(spacing: 0) {
                            CustomNumericField(numberText: $year,
                                               placeHolder: "",
                                               maximumDigits: 4)
                            HStack {
                                Text(localized(CreateSessionStrings.yearString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                    }.padding(.horizontal)
                    
                    HStack {
                        VStack {
                            HStack {
                                Text(localized(localized(CreateSessionStrings.spotsTitleString)))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            CustomNumericField(numberText: $spots,
                                               placeHolder: "",
                                               maximumDigits: 2)
                            HStack {
                                Text(localized(CreateSessionStrings.spotsDescriptionString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                        .frame(width: 100)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text(localized(localized(CreateSessionStrings.hourTitleString)))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HourSelector(hour: $hour)
                            
                            Spacer()
                            
                            HStack {
                                Text(localized(CreateSessionStrings.hourDescriptionString))
                                    .foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
                
                Button(action: {
                    didPressRegister()
                }) {
                    Text(localized(CreateSessionStrings.createButtonString))
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(!verifyFields() ? Color.gray : Color.red)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(!verifyFields())
            }
            
            if isLoading {
                LoadingView(isShowing: $isLoading,
                            title: localized(CreateSessionStrings.loadingTitleString),
                            description: localized(CreateSessionStrings.loadingDescriptionString))
            }
            
            if showErrorAlert {
                CustomAlert(isShowing: $showErrorAlert,
                            icon: "exclamationmark.circle",
                            title: localized(CreateSessionStrings.alertTitleString),
                            leftButtonText: localized(CreateSessionStrings.alertButtonString),
                            rightButtonText: "",
                            description: localized(CreateSessionStrings.alertDescriptionString),
                            leftButtonAction: { back() },
                            rightButtonAction: {},
                            isSingleButton: true)
            }
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
            self.endTextEditing()
        }
        .onReceive(viewModel.publisher) { response in
            switch response {
            case .didCreateSession:
                createdSession()
            case .didFailCreateSession, .error:
                failedCreationSession()
            }
        }
    }
    
    func didPressRegister() {
        isLoading = true
        viewModel.createSession(with: SessionCreationData(teacher: createSessionData.teacherName,
                                                          name: sessionName,
                                                          description: description,
                                                          date: "\(day)-\(month)-\(year)",
                                                          hour: "\(hour)h",
                                                          totalSpots: Int(spots) ?? 0))
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func failedCreationSession() {
        isLoading = false
        showErrorAlert = true
    }
    
    func createdSession() {
        isLoading = false
        back()
        showCreateSessionToast = true
    }
    
    func didPressCreateSessionButton() {
        viewModel.createSession(with: SessionCreationData(teacher: createSessionData.teacherName,
                                                          name: sessionName,
                                                          description: description,
                                                          date: "\(day)/\(month)/\(year)",
                                                          hour: "\(hour)h",
                                                          totalSpots: Int(spots) ?? 0))
    }
    
    func verifyFields() -> Bool {
        !sessionName.removeSpaces().isEmpty && !description.removeSpaces().isEmpty && isDateValid() && (Int(spots) ?? 0 > 0)
    }
    
    func isDateValid() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt_PT")
        dateFormatter.timeZone = TimeZone.current
        guard let inputDate = dateFormatter.date(from: "\(day)/\(month)/\(year)") else {
            return false
        }
        let today = Calendar.current.startOfDay(for: Date())
        return inputDate >= today
    }
}
