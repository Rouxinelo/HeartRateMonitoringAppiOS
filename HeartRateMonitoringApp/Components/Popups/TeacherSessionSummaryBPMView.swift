//
//  TeacherSessionSummaryBPMView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/12/2024.
//

import SwiftUI

struct TeacherSessionSummaryBPMView: View {
    @Binding var isShowing: Bool
    @State private var yOffset: CGFloat = 1000
    @State var age: Int
        
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack(spacing: 20) {
                
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(localized(TeacherSessionSummaryBPMViewStrings.titleString))
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(localized(TeacherSessionSummaryBPMViewStrings.maxBpmString).replacingOccurrences(of: "$", with: "\(getMaxBPM(for: age))"))
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(localized(TeacherSessionSummaryBPMViewStrings.descriptionString))
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        close()
                    }, label: {
                        Text(localized(TeacherSessionSummaryBPMViewStrings.buttonString))
                            .padding()
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    })
                }
            }
            .frame(width: 300)
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
        }
    }
    
    func close() {
        isShowing = false
    }
    
    func getMaxBPM(for age: Int) -> Int {
        220 - age
    }
}
