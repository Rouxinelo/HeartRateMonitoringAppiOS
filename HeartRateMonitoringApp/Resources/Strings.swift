//
//  Strings.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/03/2024.
//

import Foundation

public struct HomeScreenStrings {
    static let titleString: String = "Heart Rate Monitoring"
    static let loginString: String = "Login"
    static let registerString: String = "Register"
    static let guestString: String = "Guest Mode"
    static let settingsString: String = "Settings"
    static let guestAlertTitle: String = "Limited Functionality"
    static let guestAlertDescription: String = "Using the app as a guest only allows for limited functionality, continue?"
    static let guestAlertContinue: String = "Yes"
    static let guestAlertCancel: String = "No"
}

public struct MainMenuStrings {
    static let sectionsTitle: String = "Available Sections"
    static let classesSectionTitle: String = "Classes"
    static let classesSectionDescription: String = "View classes where you signed in"
    static let calendarSectionTitle: String = "Calendar"
    static let calendarSectionDescription: String = "View available classes and sign in"
    static let userInfoSectionTitle: String = "User"
    static let userInfoSectionDescription: String = "View user info"
    static let logoutSectionsTitle: String = "Logout"
    static let leaveSectionsTitle: String = "Leave"
    static let logoutSectionDescription: String = "Return to the initial screen"
    static let loadingViewTitle: String = "Logging you out..."
    static let loadingViewDescription: String = "See you soon!"
    static let welcomeStringGuest: String = "Hello, Guest"
    static let welcomeStringUser: String = "Hello, "
    static let logoutAlertTitle: String = "Are you sure?"
    static let logoutAlertDescription: String = ""
}
public struct LoginViewStrings {
    static let loginString: String = "Login"
    static let usernameString: String = "Username"
    static let passwordString: String = "Password"
}

public struct ScreenIds {
    static let homeScreenId: String = "HomeScreen"
}
