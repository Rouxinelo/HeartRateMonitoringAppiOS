//
//  UserSessionsModal.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 07/04/2024.
//

import SwiftUI

struct UserSessionsModal: View {
    @Binding var isShowing: Bool
    @State var sessions: [Session]
    @State var title: String
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
                        .frame(height: getNeededHeight())
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
    
    func handleSelectedSession(_ session: Session) {
        onSelectSession(session)
        close()
    }
    
    func close() {
        withAnimation {
            yOffset = 1000
        } completion: {
            isShowing = false
        }
    }
    
    func getNeededHeight() -> CGFloat {
        return CGFloat(min(sessions.count * 150, 450))
    }
    
    func getSessionsText() -> String {
        return "Found \(sessions.count) Session\(sessions.count != 1 ? "s" : "")"
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

