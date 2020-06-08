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
    @Binding var alreadySignIn: Bool

    var body: some View {
        NavigationView {
            VStack {
                Image("staticImage")
                Text("Welcome: \(session.userSession?.userProfile.userEmail ?? "...")")
            }
            .navigationBarItems(leading: SignOutButton(signIn: $alreadySignIn))
            .onAppear(perform: getUser)
        }
            
    }
    
    //MARK: Functions
    func getUser() {
        session.listen()
        
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

