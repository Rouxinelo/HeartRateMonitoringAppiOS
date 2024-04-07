//
//  UserSessionsModal.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 07/04/2024.
//

import SwiftUI

enum ModalType {
    case join
    case signOut
}

struct UserSessionsModal: View {
    @Binding var isShowing: Bool
    @State var sessions: [Session]
    @State var selectedSession: Session?
    @State var title: String
    @State var modalType: ModalType = .join
    @State var showSignoutAlert: Bool = false
    @State private var yOffset: CGFloat = 1000
    
    var onSelectSession: (Session) -> Void
    
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
                        ForEach(sessions) { session in
                            SessionSection(title: session.name,
                                           date: session.date,
                                           hour: session.hour,
                                           teacher: session.teacher,
                                           occupation: "\(session.filledSpots)/\(session.totalSpots)",
                                           onClick: { handleSelectedSession(session) })
                        }
                    }.scrollOnOverflow()
                        .frame(height: getSessionsHeight())
                }.frame(maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .topCornerRadius(40)
                    )
                    .offset(y: yOffset)
                    .animation(.linear(duration: 0.5))
            }
            if showSignoutAlert, let selectedSession = selectedSession {
                CustomAlert(isShowing: $showSignoutAlert,
                            icon: "book",
                            title: selectedSession.name,
                            leftButtonText: "Exit",
                            rightButtonText: "Sign out",
                            description: selectedSession.description ?? "",
                            leftButtonAction: { close() },
                            rightButtonAction: { close(selectedSession) },
                            isSingleButton: false)
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
    
    func handleSelectedSession(_ session: Session) {
        switch modalType {
        case .join:
            close(session)
        case .signOut:
            selectedSession = session
            showSignoutAlert = true
        }
    }
    
    func getSessionsHeight() -> CGFloat {
        return CGFloat(min(sessions.count * 150, 450))
    }
    
    func getSessionsText() -> String {
        return "Found \(sessions.count) Session\(sessions.count != 1 ? "s" : "")"
    }
    
    func close(_ selectedSession: Session? = nil) {
        if let selectedSession = selectedSession {
            onSelectSession(selectedSession)
        }
        showSignoutAlert = false
        withAnimation {
            yOffset = 1000
        } completion: {
            isShowing = false
        }
    }
}

#Preview {
    UserSessionsModal(isShowing: .constant(true),
                      sessions: [Session(id: "session1",
                                         name: "ahsduash",
                                         date: "sdhsu",
                                         hour: "du",
                                         teacher: "duhs",
                                         totalSpots: 1,
                                         filledSpots: 1),
                                 Session(id: "session2",
                                         name: "ahhcnbsduash",
                                         date: "sdhsu",
                                         hour: "du",
                                         teacher: "duhs",
                                         totalSpots: 1,
                                         filledSpots: 1)],
                      title: "Test Title",
                      onSelectSession: { _ in })
}

