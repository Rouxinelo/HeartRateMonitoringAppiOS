//
//  LanguageSelectorView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 23/03/2024.
//

import SwiftUI

struct LanguageSelectorView: View {
    @Binding var isShowing: Bool
    @State private var yOffset: CGFloat = 1000
    @State private var portugueseSelected: Bool = false
    @State private var englishSelected: Bool = true
    
    var onLanguageChange: () -> Void
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack (spacing: 30) {
                Image(LoginScreenIcons.heartIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(LanguageSelectorViewStrings.titleString)
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                HStack (spacing: 20) {
                    Button(action: {
                        selectedLanguage(language: LanguageSelectorViewStrings.portugueseString)
                    }) {
                        VStack (spacing: 10) {
                            Image(languageSelectorViewIcons.portugueseIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(50)
                                .padding(.top, 10)
                            Text(LanguageSelectorViewStrings.portugueseString)
                                .padding(.bottom, 10)
                                .foregroundColor(portugueseSelected ? .white : .black)
                        }
                        .frame(width: 100)
                        .background(portugueseSelected ? .blue : .lightGray)
                        .cornerRadius(10)
                        .shadow(radius: 50)
                    }
                    
                    Button(action: {
                        selectedLanguage(language: LanguageSelectorViewStrings.englishString)
                    }) {
                        VStack(spacing: 10) {
                            Image(languageSelectorViewIcons.englishIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(50)
                                .padding(.top, 10)
                            Text(LanguageSelectorViewStrings.englishString)
                                .padding(.bottom, 10)
                                .foregroundColor(englishSelected ? .white : .black)
                        }
                        .frame(width: 100)
                        .background(englishSelected ? .blue : .lightGray)
                        .cornerRadius(10)
                        .shadow(radius: 50)
                    }
                }

                Button(action: {
                    if portugueseSelected {
                        UserDefaults.standard.set(LanguageSelectorViewStrings.portugueseString, forKey: "AppLanguage")
                    } else {
                        UserDefaults.standard.set(LanguageSelectorViewStrings.englishString, forKey: "AppLanguage")
                    }
                    onLanguageChange()
                    close()
                }) {
                    Text(LanguageSelectorViewStrings.confirmString)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .frame(width: 250, height: 350)
            .padding(30)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .offset(y: yOffset)
            .animation(.spring())
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                yOffset = 0
            }
            getDefaultLanguage()
        }
    }
    
    func close() {
        isShowing = false
    }
    
    func getDefaultLanguage() {
        guard let languageCode = UserDefaults.standard.string(forKey: "AppLanguage") else {
            selectedLanguage(language: LanguageSelectorViewStrings.englishString)
            return
        }
        selectedLanguage(language: languageCode)
    }
    
    func selectedLanguage(language: String) {
        switch language {
        case LanguageSelectorViewStrings.englishString:
            englishSelected = true
            portugueseSelected = false
        case LanguageSelectorViewStrings.portugueseString:
            englishSelected = false
            portugueseSelected = true
        default:
            return
        }
    }
}

#Preview {
    LanguageSelectorView(isShowing: .constant(true), onLanguageChange: {})
}
