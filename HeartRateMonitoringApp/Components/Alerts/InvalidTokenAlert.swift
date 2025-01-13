//
//  InvalidTokenAlert.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/01/2025.
//

import SwiftUI

struct InvalidTokenAlert: View {
    @Binding var isShowing: Bool
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            CustomAlert(isShowing: $isShowing,
                        icon: "exclamationmark.circle",
                        title: localized(InvalidTokenAlertStrings.titleString),
                        leftButtonText: localized(InvalidTokenAlertStrings.buttonString),
                        rightButtonText: "",
                        description: localized(InvalidTokenAlertStrings.descriptionString),
                        leftButtonAction: { path.removeLast(path.count) },
                        rightButtonAction: {},
                        isSingleButton: true)
        }
    }
}
