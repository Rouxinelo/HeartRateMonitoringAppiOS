//
//  UserDetailType.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import Foundation

enum UserDetailType {
    case name
    case email
    case gender
    case age
}

extension UserDetailType {
    var image: String {
        switch self {
        case .name:
            return "person.fill"
        case .email:
            return "envelope.fill"
        case .gender:
            return "person.fill.questionmark"
        case .age:
            return "calendar"
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .name:
            return UserDetailTypeStrings.nameString
        case .email:
            return UserDetailTypeStrings.emailString
        case .gender:
            return UserDetailTypeStrings.genderString
        case .age:
            return UserDetailTypeStrings.ageString
        }
    }
}
