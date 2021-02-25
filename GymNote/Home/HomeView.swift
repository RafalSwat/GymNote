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
    
    @Binding var alreadySignIn: Bool
    @State var showProfile = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: ProfileHost(alreadySignIn: $alreadySignIn), isActive: self.$showProfile, label: {EmptyView()})
                    
                Image("staticImage")
                Text("Welcome \(session.userSession?.userProfile.userEmail ?? "...")")
                
                
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

