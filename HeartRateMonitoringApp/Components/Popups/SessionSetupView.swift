//
//  SessionSetupView.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 13/10/2024.
//

import SwiftUI

struct SessionSetupView: View {
    @Binding var isShowing: Bool
    @State var session: Session
    @State private var callId = ""
    @State private var callPassword = ""
    @State private var yOffset: CGFloat = 1000
    
    var onStartPressed: (String, String, Session) -> Void
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            ZStack {
                VStack {
                    Text(localized(SetupSessionStrings.titleString))
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                    
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundStyle(.red)
                        Text(session.name)
                            .font(.headline)
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Text(localized(SetupSessionStrings.zoomTitleString))
                            .multilineTextAlignment(.leading)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    
                    HStack {
                        Text(localized(SetupSessionStrings.zoomIdTitleString))
                        Spacer()
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    CustomTextField(searchText: $callId,
                                    isPrivateField: false,
                                    placeholder: localized(SetupSessionStrings.zoomIdPlaceholderString))
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                    HStack {
                        Text(localized(SetupSessionStrings.zoomPasswordTitleString))
                        Spacer()
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    CustomTextField(searchText: $callPassword,
                                    isPrivateField: false,
                                    placeholder: localized(SetupSessionStrings.zoomPasswordPlaceholderString))
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        onStartPressed(callId, callPassword, session)
                        close()
                    }) {
                        Text(localized(SetupSessionStrings.buttonString))
                            .padding()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 150)
                            .background(callId.isEmpty || callPassword.isEmpty ? Color.gray : Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    .disabled(callId.isEmpty || callPassword.isEmpty)
                }
                
                Button(action: {
                    close()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.red)
                        .fontWeight(.bold)
                        .font(.headline)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            .frame(width: 250, height: 450, alignment: .bottom)
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
}
