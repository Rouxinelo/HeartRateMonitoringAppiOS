//
//  SessionDetailScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/03/2024.
//

import SwiftUI

struct SessionDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var didSignIn: Bool
    @State var isGuest: Bool
    @State var session: Session
    @State var username: String?
    @State var imageName: String = "exercise-cartoon-1"
    @State var showSignInLoading: Bool = false
    @State var showFailedToast: Bool = false
    @StateObject var viewModel = SessionDetailViewModel()
    
    var body: some View {
        ZStack {
            VStack (alignment: .center, spacing: 20) {
                Text(localized(SessionDetailStrings.titleString))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                VStack (spacing: 10){
                    HStack {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .cornerRadius(20)
                            .shadow(radius: 20)
                    }
                    HStack {
                        Text(session.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    VStack (spacing: 0) {
                        HStack {
                            Image(systemName: "book.fill")
                            Text(session.teacher)
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text(session.date)
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "calendar")
                        }
                        HStack {
                            Spacer()
                            Text(session.hour)
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "clock.fill")
                        }
                    }
                    
                    VStack (spacing: 0) {
                        HStack {
                            Text(localized(SessionDetailStrings.sessionDescriptionString))
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        Text(session.description ?? localized(SessionDetailStrings.noDescriptionString)).fontWeight(.semibold)
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 25, height: 25)
                        Text("\(session.filledSpots)/\(session.totalSpots)").font(.title).fontWeight(.bold)
                        Spacer()
                    }
                }.scrollOnOverflow()
                Button(action: {
                    didPressSignIn()
                }, label: {
                    Text(getSignInButtonText())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(session.filledSpots == session.totalSpots || isGuest ? .gray : .red)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }).disabled(session.filledSpots >= session.totalSpots)
                

            }
            .padding()
            .navigationBarBackButtonHidden()
            .onReceive(viewModel.publisher) { recievedValue in
                switch recievedValue {
                case .didSignInSuccessfully:
                    signIn()
                case .error:
                    failedSignIn()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackButton(onClick: { back() })
                }
            }.onAppear {
                imageName = getRandomImage()
            }.swipeRight {
                back()
            }
            
            if showSignInLoading {
                LoadingView(isShowing: $showSignInLoading,
                            title: localized(SessionDetailStrings.loadingTitle),
                            description: localized(SessionDetailStrings.loadingDescription))
                .ignoresSafeArea(.all)
            }
            
            if showFailedToast {
                CustomToast(isShowing: $showFailedToast,
                            iconName: "info.circle.fill",
                            message: localized(SessionDetailStrings.toastMessage))
            }
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func signIn() {
        showSignInLoading = false
        back()
        didSignIn = true
    }
    
    func didPressSignIn() {
        guard let username = username else { return }
        showSignInLoading = true
        viewModel.signIn(for: username, sessionId: session.id)
    }
    
    func failedSignIn() {
        showSignInLoading = false
        showFailedToast = true
    }
    
    func getRandomImage() -> String {
        let baseString = "exercise-cartoon-"
        let randomNumber = Int(arc4random_uniform(6)) + 1
        return baseString + String(randomNumber)
    }
    
    func getSignInButtonText() -> String {
        if isGuest {
            return localized(SessionDetailStrings.signInButtonGuest)
        } else if session.totalSpots <= session.filledSpots {
            return localized(SessionDetailStrings.signInButtonFull)
        } else {
            return localized(SessionDetailStrings.signInButton)
        }
    }
}
