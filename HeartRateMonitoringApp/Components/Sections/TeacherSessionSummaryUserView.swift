//
//  TeacherSessionSummaryUserView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/11/2024.
//

import SwiftUI

struct TeacherSessionSummaryUserView: View {
    @State var user: User
    @State var measurements: [Int]
    let onClick: (User) -> Void

    var body: some View {
        ZStack {
            Button(action: {
                onClick(user)
            }) {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "info.circle")
                            .font(.headline)
                            .foregroundStyle(.red)
                    }
                    .opacity(isDangerousBPM() ? 1 : 0)
                    .padding(.horizontal)
                    HStack(spacing: 10) {
                        VStack {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.red)
                                Text(getFormattedName(for: user))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            Spacer()
                            
                            HStack {
                                Text(localized(TeacherSessionSummaryUserViewStrings.userDetailsString))
                                    .font(.headline)
                                Spacer()
                            }
                            
                            HStack {
                                Text("\(user.age) \(getGenderEmoji(user.gender))")
                                Spacer()
                            }
                            .font(.title2)
                            .fontWeight(.bold)
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.up")
                                    .foregroundStyle(.red)
                                Text("\(measurements.max() ?? 0)")
                            }.foregroundStyle(isDangerousBPM() ? .red : .black)
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "alternatingcurrent")
                                    .foregroundStyle(.red)
                                Text("\(measurements.reduce(0, +) / max(measurements.count, 1))")
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.down")
                                    .foregroundStyle(.red)
                                Text("\(measurements.min() ?? 0)")
                            }
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                }
                .foregroundStyle(.black)
            }
            .padding(.horizontal)
        }.disabled(!isDangerousBPM())
    }
    
    func getGenderEmoji(_ gender: String) -> String {
        switch gender.uppercased() {
        case "M":
            return "👦🏻"
        case "F":
            return "👩🏻"
        default:
            return "👤"
        }
    }
    
    func getFormattedName(for user: User) -> String {
        guard let firstNameChar = user.firstName.first else { return "" }
        return "\(firstNameChar). \(user.lastName)"
    }
    
    func isDangerousBPM() -> Bool {
        (220 - user.age) <= measurements.max() ?? 0
    }
}
