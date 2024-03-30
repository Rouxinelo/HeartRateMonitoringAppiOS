//
//  String.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 29/03/2024.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func shortenFirstName() -> String {
        guard !self.isEmpty else { return "" }
        let words = self.components(separatedBy: " ")
        return "\(String(words.first?.first ?? Character(""))). \(words.last ?? "")"
    }
}
