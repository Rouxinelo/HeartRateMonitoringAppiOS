//
//  CalendarSection.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct SessionSection: View {
    let title: String
    let date: String
    let hour: String
    let teacher: String
    let occupation: String
    let onClick: () -> Void
    
    var body: some View {
        Button(action: {
            onClick()
        }) {
            HStack {
                VStack (spacing: 5){
                    HStack {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                        Text(date)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "book.fill")
                            .foregroundColor(.red)
                        Text(teacher)
                            .foregroundColor(.black)
                    }
                    HStack {
                        
                        Image(systemName: "clock.fill")
                            .foregroundColor(.red)
                        Text(hour)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "person.fill")
                            .foregroundColor(.red)
                        Text(occupation)
                            .foregroundColor(.black)
                    }
                }.padding()
                Image(systemName: "chevron.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.red)
            }
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
        }
    }
}
