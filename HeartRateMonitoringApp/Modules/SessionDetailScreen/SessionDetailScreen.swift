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
    @State var imageName: String = "exercise-cartoon-1"
    
    var body: some View {
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(onClick: { back() })
            }
        }.onAppear {
            imageName = getRandomImage()
        }.swipeRight {
            back()
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func didPressSignIn() {
        back()
        didSignIn = true
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

#Preview {
    SessionDetailScreen(didSignIn: .constant(true),
                        isGuest: false,
                        session: Session(id: "test123",
                                         name: "Example Session",
                                         date: "11/11",
                                         hour: "11h",
                                         teacher: "Example Teacher",
                                         totalSpots: 10,
                                         filledSpots: 10))
}
