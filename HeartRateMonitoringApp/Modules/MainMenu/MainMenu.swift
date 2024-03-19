//
//  MainMenu.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 18/03/2024.
//

import SwiftUI

struct MainMenu: View {
    let userType: UserType
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack {
                Text(getUserType()).font(.headline).fontWeight(.bold)
            }
        }
    }
    
    func getUserType() -> String {
        switch userType {
        case .guest:
            return "Hello, Guest"
        case .login(let name):
            return "Hello, \(name)"
        }
    }
}

#Preview {
    MainMenu(userType: .guest)
}
