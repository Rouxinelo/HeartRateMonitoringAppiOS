//
//  JoinSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import SwiftUI

struct JoinSessionScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var showConnectionModal: Bool = false
    @State var devices = [MockDevice]()
    var preSessionData: PreSessionData
    
    var body: some View {
        ZStack {
            VStack (spacing: 10) {
                HStack (alignment: .center) {
                    CustomBackButton(onClick: { back() })
                    Spacer()
                    Text(localized(JoinSessionStrings.titleString))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                HStack {
                    VStack (spacing: 10){
                        Image("heart-rate").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100)
                        Text(localized(JoinSessionStrings.detailsString))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        VStack (spacing: 10) {
                            Text(preSessionData.session.name)
                            Text(preSessionData.session.description ?? localized(JoinSessionStrings.noDescriptionString))
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(.red)
                                Text(preSessionData.session.teacher)
                            }
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(.red)
                                Text(preSessionData.session.hour)
                            }
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.red)
                                Text("\(preSessionData.session.filledSpots)/\(preSessionData.session.totalSpots)")
                            }
                        }.font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                    }
                    
                }
                Spacer()
                MultipleTextButton(action: {
                    showConnectionModal = true
                    addDevicesPeriodically()
                }, title: localized(JoinSessionStrings.joinButtonString), description: localized(JoinSessionStrings.connectSensorString))
                .padding()
            }
            
            if showConnectionModal {
                ConnectSensorModal(isShowing: $showConnectionModal,
                                   devices: $devices,
                                   title: localized(JoinSessionStrings.connectSensorString),
                                   onSelectedDevice: { device in
                    goToSession(device)
                })
            }
        }.swipeRight {
            back()
        }
        .navigationDestination(for: SessionData.self, destination: { sessionData in
            SessionScreen(path: $path, sessionData: sessionData)
        })
        .navigationBarBackButtonHidden()
    }
    
    func addDevicesPeriodically() {
        devices.append(MockDevice(name: "876543210", batteryPercentage: 25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.devices.append(MockDevice(name: "012345678", batteryPercentage: 100))
        }
    }
    
    func goToSession(_ device: MockDevice) {
        showConnectionModal.toggle()
        path.append(SessionData(session: SessionSimplified(id: preSessionData.session.id,
                                                           name: preSessionData.session.name,
                                                           teacher: preSessionData.session.teacher),
                                user: UserSimplified(username: preSessionData.user.username),
                                device: device))
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    JoinSessionScreen(path: .constant(NavigationPath()), preSessionData: PreSessionData(session: Session(id: "testID",
                                                                                              name: "Test Name",
                                                                                              date: "11/11",
                                                                                              hour: "11h",
                                                                                              teacher: "Test Teacher",
                                                                                              totalSpots: 1,
                                                                                              filledSpots: 1),
                                                                             user: User(username: "testUsername",
                                                                                        firstName: "Test",
                                                                                        lastName: "Name",
                                                                                        email: "testEmail@testemail.com",
                                                                                        gender: "M",
                                                                                        age: 11,
                                                                                        password: "ucdu")))
}
