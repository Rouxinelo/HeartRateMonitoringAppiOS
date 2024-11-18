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
    @Environment(\.presentationMode) var presentationMode
    @State var details: [UserDetail]
    
    var body: some View {
        VStack (alignment: .center, spacing: 50){
            VStack (alignment: .center, spacing: 25){
                Text(localized(UserDetailTypeStrings.titleString))
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
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton(onClick: { back() })
            }
        }.swipeRight {
            back()
        }
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
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}
