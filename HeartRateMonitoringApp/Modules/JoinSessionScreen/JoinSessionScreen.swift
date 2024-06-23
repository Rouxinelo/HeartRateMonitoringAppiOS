//
//  JoinSessionScreen.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 08/04/2024.
//

import SwiftUI
import MovesenseApi

struct JoinSessionScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State var showEnterSessionLoading: Bool = false
    @State var showFailedEnterAlert: Bool = false
    @State var showBluetoothProblemsAlert: Bool = false
    @State var showConnectionModal: Bool = false {
        didSet { if !showConnectionModal
            { viewModel.stopScanningForDevices() }
        }
    }
    @State var devices = [DeviceRepresentable]()
    @StateObject var viewModel = JoinSessionViewModel()
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
                    verifyBluetoothState()
                }, title: localized(JoinSessionStrings.joinButtonString), description: localized(JoinSessionStrings.connectSensorString))
                .padding()
            }
            
            if showConnectionModal {
                ConnectSensorModal(isShowing: $showConnectionModal,
                                   devices: $devices,
                                   title: localized(JoinSessionStrings.connectSensorString),
                                   onSelectedDevice: { device in
                    viewModel.connectToDevice(device)
                })
            }
            if showEnterSessionLoading {
                LoadingView(isShowing: $showEnterSessionLoading,
                            title: localized(JoinSessionStrings.loadingTitleString),
                            description: localized(JoinSessionStrings.loadingDescriptionString))
            }
            if showFailedEnterAlert {
                CustomAlert(isShowing: $showFailedEnterAlert,
                            icon: "exclamationmark.circle",
                            title: localized(JoinSessionStrings.alertTitleString),
                            leftButtonText: localized(JoinSessionStrings.alertButtonString),
                            rightButtonText: "",
                            description: localized(JoinSessionStrings.alertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: {},
                            isSingleButton: true)
            }
            if showBluetoothProblemsAlert {
                CustomAlert(isShowing: $showBluetoothProblemsAlert,
                            icon: "exclamationmark.circle",
                            title: localized(JoinSessionStrings.bluetoothAlertTitleString),
                            leftButtonText: localized(JoinSessionStrings.bluetoothAlertButtonString),
                            rightButtonText: "",
                            description: localized(JoinSessionStrings.bluetoothAlertDescriptionString),
                            leftButtonAction: {},
                            rightButtonAction: {},
                            isSingleButton: true)
            }
        }.swipeRight {
            back()
        }
        .navigationDestination(for: SessionData.self, destination: { sessionData in
            let view = SessionScreen(path: $path, sessionData: sessionData)
            view.setSensorManager(viewModel.getSensorManager())
            return view
        })
        .onReceive(viewModel.publisher) { response in
            switch response {
            case .didEnterSession:
                path.append(SessionData(session: SessionSimplified(id: preSessionData.session.id,
                                                                   name: preSessionData.session.name,
                                                                   teacher: preSessionData.session.teacher),
                                        username: preSessionData.user.username))
            case .didFailOperation:
                showFailedEnterAlert = true
            case .bluetoothPoweredOn:
                startScanningForDevices()
            case .bluetoothPoweredOff, .bluetoothConnectionError:
                showBluetoothProblemsAlert = true
            case .didDiscoverNewDevice(let device):
                devices.append(device)
            case .didConnectToDevice:
                goToSession()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func verifyBluetoothState() {
        viewModel.checkForBluetoothConnection()
    }
    
    func startScanningForDevices() {
        showConnectionModal = true
        viewModel.startScanningForDevices()
    }
    
    func goToSession() {
        showConnectionModal.toggle()
        showEnterSessionLoading = true
        viewModel.sendEnterData(username: preSessionData.user.username,
                                sessionId: preSessionData.session.id)
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
