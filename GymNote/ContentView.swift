//
//  ContentView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var alreadySignIn = false
    
    var body: some View {
        ZStack {
            
            if self.alreadySignIn {
                MainContainer(alreadySignIn: $alreadySignIn)
            } else {
                WelcomeView(alreadySignIn: $alreadySignIn)
            }
        }.onAppear {
            if self.session.tryAutoSignIn() {
                self.alreadySignIn = true
            } else {
                self.alreadySignIn = false
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(FireBaseSession())
    }
}
