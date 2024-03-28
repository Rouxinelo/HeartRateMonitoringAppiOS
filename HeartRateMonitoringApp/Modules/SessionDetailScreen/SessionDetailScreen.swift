//
//  SessionDetailScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/03/2024.
//

import SwiftUI

struct SessionDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var session: Session

    var body: some View {
        VStack (alignment: .center, spacing: 20) {
            Text("About This Session")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack (spacing: 15){
                HStack {
                    Image("exercise-cartoon-5")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                }
                HStack {
                    Text("Session Name")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                VStack (spacing: 0) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("J Rouxinol")
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
                
                VStack (spacing: 20) {
                    HStack {
                        Text("Session Description")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Text(session.description ?? "No description was provided for this session.")
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "person.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 25, height: 25)
                    Text("\(session.filledSpots)/\(session.totalSpots)").font(.title).fontWeight(.bold)
                    Spacer()
                }
            }
            Button(action: {
            }, label: {
                Text("Sign in")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(session.filledSpots < session.totalSpots ? .red : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }).disabled(session.filledSpots < session.totalSpots)
        }
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(onClick: { back() })
            }
        }
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func getRandomImage() -> String {
        let baseString = "exercise-cartoon-"
        let randomNumber = Int(arc4random_uniform(5)) + 1
        return "baseString\(randomNumber)"
    }
}

#Preview {
    SessionDetailScreen(session: Session(name: "Example Session", date: "11/11", hour: "11h", teacher: "Example Teacher", totalSpots: 10, filledSpots: 9))
}
