//
//  TeacherMenuScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 09/08/2024.
//

import SwiftUI

struct TeacherMenuScreen: View {
    @Binding var path: NavigationPath
    @State var teacher: Teacher
    
    var body: some View {
        ZStack {
            VStack {
                Text("Hola Negro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            VStack (spacing: 20) {
                Image(LoginScreenIcons.heartIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .center)
                Text(localized(MainMenuStrings.sectionsTitle))
                    .font(.title)
                    .fontWeight(.bold)
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .red,
                                    sectionIcon: MainMenuIcons.myClassesIcon,
                                    sectionTitle: localized(MainMenuStrings.classesSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.classesSectionDescription),
                                    isUnavailable: false,
                                    sectionAction: {
                    })
                    MainMenuSection(sectionColor: .green,
                                    sectionIcon: MainMenuIcons.calendarIcon,
                                    sectionTitle: localized(MainMenuStrings.calendarSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.calendarSectionDescription),
                                    isUnavailable: false,
                                    sectionAction: {
                        })
                }
                HStack (spacing: 5) {
                    MainMenuSection(sectionColor: .yellow,
                                    sectionIcon: MainMenuIcons.myClassesIcon,
                                    sectionTitle: localized(MainMenuStrings.classesSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.classesSectionDescription),
                                    isUnavailable: false,
                                    sectionAction: {
                    })
                    MainMenuSection(sectionColor: .blue,
                                    sectionIcon: MainMenuIcons.myClassesIcon,
                                    sectionTitle: localized(MainMenuStrings.classesSectionTitle),
                                    sectionDescription: localized(MainMenuStrings.classesSectionDescription),
                                    isUnavailable: false,
                                    sectionAction: {
                    })
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
