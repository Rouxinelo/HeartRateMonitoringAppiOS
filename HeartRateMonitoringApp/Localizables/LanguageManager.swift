//
//  LanguageManager.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 28/04/2024.
//

import Foundation

class LanguageManager {
    let supportedLanguages = ["en", "pt"]
    
    var currentLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
}

public func localized(_ string: String) -> String {
    let currentLanguage = LanguageManager().currentLanguage
    guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
          let languageBundle = Bundle(path: path) else {
        return string
    }
    return NSLocalizedString(string, bundle: languageBundle, comment: "")
}

public func getCurrentLanguage() -> String {
    return LanguageManager().currentLanguage
}
