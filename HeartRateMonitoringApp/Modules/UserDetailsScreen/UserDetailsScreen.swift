//
//  UserDetailsScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct UserDetail: Hashable {
    var detailType: UserDetailType
    var description: String
}

struct UserDetailsScreen: View {
    let details: [UserDetail] = [UserDetail(detailType: .name, description: "test name"),
                                 UserDetail(detailType: .email, description: "testemail@testemail.com"),
                                 UserDetail(detailType: .gender, description: "M"),
                                 UserDetail(detailType: .age, description: "50")]
    var body: some View {
        VStack (alignment: .center, spacing: 50){
            VStack (alignment: .center, spacing: 25){
                Text("Your Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                CircularAvatar(backgroundColor: .red, 
                               textColor: .white,
                               text: getInitials(for: details))
            }
            VStack (spacing: 20) {
                ForEach(details, id: \.self) { detail in
                    UserDetailsSection(image: detail.detailType.image,
                                       title: detail.detailType.sectionTitle,
                                       description: detail.description)
                }
            }
            Spacer()
        }.padding()
    }
    
    func getInitials(for details: [UserDetail]) -> String {
        guard let name = findUserName(details) else { return "??" }
        return String(name.components(separatedBy: " ").compactMap { $0.first })
    }
                           
    func findUserName(_ details: [UserDetail]) -> String? {
        for detail in details {
            if detail.detailType == UserDetailType.name {
                return detail.description
            }
        }
        return nil
    }
}

#Preview {
    UserDetailsScreen()
}
