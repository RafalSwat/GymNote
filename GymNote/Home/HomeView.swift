//
//  HomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    
    @EnvironmentObject var session: FireBaseSession
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.calendar) var calendar

    @Binding var alreadySignIn: Bool
    @State var showProfile = false
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }
    let cellSize = UIScreen.main.bounds.size.width/20
    let grayCellBackground = LinearGradient(gradient: Gradient(colors: [.customLight, .customDark]), startPoint: .bottomLeading, endPoint: .topTrailing)
    let orangeCellbackground = LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: ProfileHost(alreadySignIn: $alreadySignIn), isActive: self.$showProfile, label: {EmptyView()})

                if #available(iOS 14.0, *) {
                    CalendarView(interval: year) { date in

                        Text("?")
                            .hidden()
                            .padding(cellSize)
                            .background(Calendar.current.isDateInToday(date) ? orangeCellbackground : grayCellBackground)
                            .clipShape(Rectangle())
                            .cornerRadius(3)
                            .shadow(color: Color.customShadow, radius: 3, x: -2, y: 2)
                            .padding(1)
                            .overlay(
                                VStack {
                                    HStack {
                                        Text(String(self.calendar.component(.day, from: date)))
                                            .fontWeight(Calendar.current.isDateInToday(date) ? .heavy    : .regular)
                                        Spacer()
                                    }
                                    Spacer()
                                }.padding(4)
                            )
                    }
                    .padding(20)
                } else {
                    // Fallback on earlier versions
                }
                
//                Image("staticImage")
//                Text("Welcome \(session.userSession?.userProfile.userEmail ?? "...")")
                
                
            }
            
            .navigationBarItems(leading: SignOutButton(signIn: $alreadySignIn),
                                trailing:  ProfileButton(showProfile: self.$showProfile))
            .navigationBarTitle("Home", displayMode: .inline)
            
        }
    }  
}

struct HomeView_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    @State static var prevAlreadySignIn = true
    
    static var previews: some View {
        NavigationView {
            HomeView(alreadySignIn: $prevAlreadySignIn)
                .environmentObject(session)
        }
    }
}

