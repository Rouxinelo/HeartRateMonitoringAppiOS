//
//  CustomBackButton.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 24/03/2024.
//

import SwiftUI

struct CustomBackButton: View {
    let onClick: () -> Void
    var body: some View {
        Button(action: {
            onClick()
        }) {
            Image(systemName: "chevron.backward").foregroundStyle(.red).fontWeight(.bold).font(.headline)
        }
    }
}

#Preview {
    CustomBackButton(onClick: {})
}
