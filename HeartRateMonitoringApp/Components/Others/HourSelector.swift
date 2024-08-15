//
//  HourSelector.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 12/08/2024.
//

import SwiftUI

struct HourSelector: View {
    @Binding var hour: Int
    
    var body: some View {
        HStack {
            Button(action: {
                removeHour()
            }) {
                Image(systemName: "minus.square.fill")
                    .fontWeight(.bold)
                    .font(.largeTitle)
            }
            .foregroundStyle(canRemoveHour() ? .red : .gray)
            .disabled(canRemoveHour() ? false : true)

            Text("\(hour)h")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(action: {
                addHour()
            }) {
                Image(systemName: "plus.square.fill")
                    .fontWeight(.bold)
                    .font(.largeTitle)
            }
            .foregroundStyle(canAddHour() ? .red : .gray)
            .disabled(canAddHour() ? false : true)
        }
    }
    
    func addHour() {
        hour += 1
    }
    
    func removeHour() {
        hour -= 1
    }
    
    func canAddHour() -> Bool {
        hour < 23
    }
    
    func canRemoveHour() -> Bool {
        hour > 0
    }
}
