//
//  RegisterScreenAgeField.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 30/03/2024.
//

import SwiftUI

struct RegisterScreenGenderField: View {
    @Binding var isMaleSelected: Bool
    @Binding var isFemaleSelected: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            CustomRadioButton(isSelected: $isMaleSelected, text: "M")
                .onChange(of: isMaleSelected,
                          { handleRadioButtonChange(.male) })
            CustomRadioButton(isSelected: $isFemaleSelected, text: "F")
                .onChange(of: isFemaleSelected,
                          { handleRadioButtonChange(.female) })
        }
    }
    
    func handleRadioButtonChange(_ genderChanged: Gender) {
        switch genderChanged {
        case .male:
            isFemaleSelected = !isMaleSelected
        case .female:
            isMaleSelected = !isFemaleSelected
        }
    }
}

#Preview {
    RegisterScreenGenderField(isMaleSelected: .constant(false), isFemaleSelected: .constant(false))
}
