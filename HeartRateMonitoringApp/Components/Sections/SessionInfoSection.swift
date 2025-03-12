//
//  SessionInfoSection.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 23/06/2024.
//

import Foundation
import SwiftUI

struct SessionInfoSection: View {
    @State var imageName: String
    @State var text: String
    @State var spacing: CGFloat = 8
    
    var body: some View {
        HStack (spacing: spacing) {
            Image(systemName: imageName)
            Text(text).font(.headline).fontWeight(.bold)
        }
    }
}
