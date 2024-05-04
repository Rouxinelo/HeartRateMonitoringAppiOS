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
            return localized(UserDetailTypeStrings.nameString)
        case .email:
            return localized(UserDetailTypeStrings.emailString)
        case .gender:
            return localized(UserDetailTypeStrings.genderString)
        case .age:
            return localized(UserDetailTypeStrings.ageString)
        }
    }
}
