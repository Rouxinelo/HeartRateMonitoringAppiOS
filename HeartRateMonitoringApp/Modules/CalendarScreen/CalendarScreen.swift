//
//  CalendarScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct Session: Hashable {
    var name: String
    var date: String
    var hour: String
    var teacher: String
    var totalSpots: Int
    var filledSpots: Int
    var description: String?
}

struct CalendarScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var sessions: [Session]
    
    var body: some View {
        VStack (alignment: .center, spacing: 50) {
            Text("Available Sessions")
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack (spacing: 0) {
                ForEach(sessions, id: \.self) { session in
                    CalendarSection(title: session.name, 
                                    date: session.date,
                                    hour: session.hour,
                                    teacher: session.teacher,
                                    occupation: getOccupationString(totalSpots: session.totalSpots,
                                                                    occupiedSpots: session.filledSpots),
                                    onClick: { clickedSession(session) })
                }
            }.scrollOnOverflow()
            Spacer()
        }
        .padding()
        .navigationDestination(for: Session.self, destination: { session in
            SessionDetailScreen(session: session)
        })
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
    
    func getOccupationString(totalSpots: Int, occupiedSpots: Int) -> String {
        "\(occupiedSpots)/\(totalSpots)"
    }
    
    func clickedSession(_ session: Session) {
        path.append(session)
    }
}

#Preview {
    CalendarScreen(path: .constant(NavigationPath()), sessions: [Session(name: "Pilates Clinico",
                                                                         date: "24/03",
                                                                         hour: "19h",
                                                                         teacher: "J. Rouxinol",
                                                                         totalSpots: 10,
                                                                         filledSpots: 10),
                                                                 Session(name: "Fisioterapia",
                                                                         date: "30/03",
                                                                         hour: "23h",
                                                                         teacher: "J. Saias",
                                                                         totalSpots: 15,
                                                                         filledSpots: 5)])
}
