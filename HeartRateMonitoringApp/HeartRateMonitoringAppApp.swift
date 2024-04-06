//
//  HeartRateMonitoringAppApp.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/03/2024.
//

import SwiftUI

@main
struct HeartRateMonitoringAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .preferredColorScheme(.light)
        }
    }
}
