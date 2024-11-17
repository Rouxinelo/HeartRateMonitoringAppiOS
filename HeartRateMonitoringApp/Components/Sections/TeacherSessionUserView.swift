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
                            Text("\(maxHR)")
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "alternatingcurrent")
                            .foregroundStyle(.red)
                            Text("\(avgHR)")
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.down")
                                .foregroundStyle(.red)
                            Text("\(minHR)")
                        }
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
            }
        }.onAppear {
            setNewValues()
        }
        .padding(.horizontal)
    }
    
    func getHRString(_ heartRate: Int) -> String {
        "\(heartRate) BPM"
    }
    
    func setNewValues() {
        guard measurements.count > 0 else { return }
        maxHR = measurements.max() ?? 0
        minHR = measurements.min() ?? 0
        currentHR = measurements.last ?? 0
        avgHR = measurements.reduce(0, +) / max(measurements.count, 1)
    }
}
