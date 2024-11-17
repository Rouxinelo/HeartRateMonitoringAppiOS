//
//  TeacherSessionUserView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 17/11/2024.
//

import SwiftUI

struct TeacherSessionUserView: View {
    @State var isActive: Bool
    @State var name: String
    @State var currentHR: Int = 0
    @State var maxHR: Int = 0
    @State var avgHR: Int = 0
    @State var minHR: Int = 0
    @State var flash: Bool = false
    @State var measurements: [Int]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text(isActive ? "Active" : "Inactive")
                    Image(systemName: isActive ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundStyle(isActive ? .green : .yellow)
                }.font(.headline)
                HStack(spacing: 10) {
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.red)
                            Text(name)
                            Spacer()
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        Spacer()
                        
                        HStack {
                            Text("Current HR:")
                                .font(.headline)
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                            Text(getHRString(currentHR))
                            Spacer()
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                    }
                    
                    
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.up")
                            .foregroundStyle(.red)
                            Text(getHRString(maxHR))
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "alternatingcurrent")
                            .foregroundStyle(.red)
                            Text(getHRString(avgHR))
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.down")
                                .foregroundStyle(.red)
                            Text(getHRString(minHR))
                        }
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding()
                .background(flash ? getFlashColorAnimation() : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                .onAppear {
                    triggerFlashAnimation()
                }
            }
        }.onAppear {
            setNewValues()
        }
        .padding(.horizontal)
    }
    
    func getHRString(_ heartRate: Int) -> String {
        "\(heartRate) BPM"
    }
    
    func triggerFlashAnimation() {
        withAnimation(.easeInOut(duration: 0.1)) {
            flash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                flash = false
            }
        }
    }
    
    func getFlashColorAnimation() -> Color {
        isActive ? .green : .yellow
    }
    
    func setNewValues() {
        guard measurements.count > 0 else { return }
        maxHR = measurements.max() ?? 0
        minHR = measurements.min() ?? 0
        currentHR = measurements.last ?? 0
        avgHR = measurements.reduce(0, +) / max(measurements.count, 1)
    }
}
