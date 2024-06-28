//
//  ConnectSensorModal.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 10/04/2024.
//

import SwiftUI

struct DeviceRepresentable: Hashable {
    var name: String
    var batteryPercentage: Int?
}

struct ConnectSensorModal: View {
    @Binding var isShowing: Bool
    @Binding var devices: [DeviceRepresentable]
    @State var title: String
    @State var showConnectDevice: Bool = false
    @State private var yOffset: CGFloat = 1000
    
    var onSelectedDevice: (DeviceRepresentable) -> Void
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                Spacer()
                VStack {
                    Color.gray.cornerRadius(20)
                        .frame(height: 5)
                        .padding(.horizontal, 50)
                        .padding(.top, 20)
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Text(getSessionsText())
                        .font(.title)
                        .fontWeight(.bold)
                    VStack (spacing: 0) {
                        ForEach(devices, id: \.self) { device in
                            HStack  {
                                Button(action: {
                                    close(device)
                                }) {
                                    Image("movesense-icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text(device.name).font(.headline)
                                    Spacer()
                                }.padding(.horizontal, 10)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2)
                                    }
                                    .foregroundStyle(.black)
                                    .padding(10)
                            }
                        }
                    }.scrollOnOverflow()
                        .frame(height: getSessionsHeight()).padding(.bottom)
                }.frame(maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .topCornerRadius(40)
                    )
                    .offset(y: yOffset)
                    .animation(.linear(duration: 0.5))
            }
        }.ignoresSafeArea()
            .onAppear {
                withAnimation {
                    yOffset = 0
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.height > 0 {
                        close()
                    }
                }))
    }
    
    func getSessionsHeight() -> CGFloat {
        return CGFloat(min(devices.count * 60, 450))
    }
    
    func getSessionsText() -> String {
        return "Found \(devices.count) Device\(devices.count != 1 ? "s" : "")"
    }
    
    func close(_ device: DeviceRepresentable? = nil) {
        if let device = device {
            onSelectedDevice(device)
        }
        withAnimation {
            yOffset = 1000
        } completion: {
            isShowing = false
        }
    }
}

#Preview {
    ConnectSensorModal(isShowing: .constant(true),
                       devices: .constant([DeviceRepresentable(name: "Movesense1"),
                                           DeviceRepresentable(name: "Movesense1"),
                                           DeviceRepresentable(name: "Movesense1")]),
                       title: "Nearby Devices",
                       onSelectedDevice: { _ in })
}
