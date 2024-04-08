//
//  View.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 07/04/2024.
//

import Foundation
import SwiftUI

extension View {
    func topCornerRadius(_ radius: CGFloat) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: [.topLeft, .topRight]))
    }
    
    func bottomCornerRadius(_ radius: CGFloat) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: [.bottomLeft, .bottomRight]))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
