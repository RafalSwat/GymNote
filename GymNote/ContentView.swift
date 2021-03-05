//
//  ContentView.swift
//  GymNote
//
//  Created by Rafał Swat on 06/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @State var alreadySignIn = false
    
    var body: some View {
        ZStack {
            if self.alreadySignIn {
                ZStack {
                    if session.userSession == nil {
                        Indicator()
                    } else {
                        MainContainer(alreadySignIn: $alreadySignIn)
                    }
                }
                .onAppear{
                    sleep(2)
                    self.getUser()
                }
            } else {
                WelcomeView(alreadySignIn: $alreadySignIn)
            }
        }.onAppear {
            self.alreadySignIn = self.session.tryAutoSignIn()
        }
        
    }
    //MARK: Functions
    func getUser() {
        self.session.listen()
    }
    
}
@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(FireBaseSession())
    }
}
