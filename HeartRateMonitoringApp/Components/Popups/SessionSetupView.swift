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
                    Text("Session Setup")
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
                        Text("Live Stream Setup")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Your Zoom call ID")
                        Spacer()
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    CustomTextField(searchText: $callId,
                                    isPrivateField: false,
                                    placeholder: "Zoom ID")
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Your Zoom call password")
                        Spacer()
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    CustomTextField(searchText: $callPassword,
                                    isPrivateField: false,
                                    placeholder: "Zoom Password")
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        onStartPressed(callId, callPassword, session)
                        close()
                    }) {
                        Text("Start")
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
            .frame(width: 250, height: 400, alignment: .bottom)
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
