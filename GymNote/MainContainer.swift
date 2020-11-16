//
//  MainContainer.swift
//  GymNote
//
//  Created by Rafał Swat on 29/05/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct MainContainer: View {
    @EnvironmentObject var session: FireBaseSession
    @State private var selected = 0
    @Binding var alreadySignIn: Bool
    
    
    var body: some View {
        
        TabView(selection: $selected) {
            HomeView(alreadySignIn: $alreadySignIn)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .font(.largeTitle)
                    .padding()
            }.tag(0)
            if #available(iOS 14.0, *) {
                NoteView()
                    .tabItem {
                        VStack {
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                            Text("Note")
                        }
                        .font(.largeTitle)
                        .padding()
                    }.tag(1)
            } else {
                // Fallback on earlier versions
            }
            ProfileHost()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .font(.largeTitle)
                    .padding()
            }.tag(2)
            //StatsView()
            ChartView()
                .onAppear {
                    session.downloadUserStatisticsFromDB(userID: (session.userSession?.userProfile.userID)!)
                }
                .tabItem {
                    VStack {
                        Image(systemName: "waveform.path.ecg")
                        Text("Stats")
                    }
                    .font(.largeTitle)
                    .padding()
            }.tag(3)
            
        }
        .accentColor(Color.orange)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct MainContainer_Previews: PreviewProvider {
    
    @State static var session = FireBaseSession()
    @State static var prevAlreadySignIn = true
    
    static var previews: some View {
        MainContainer(alreadySignIn: $prevAlreadySignIn).environmentObject(session)
    }
}
