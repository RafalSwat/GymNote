//
//  WelcomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 04/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    //MARK: Properties
    @EnvironmentObject var authSession: AuthSessionStore
    @State private var isRegistered = false
    
    //MARK: View
    var body: some View {
        NavigationView {
            KeyboardHost {
                VStack {
                    
                    Image("staticImage")
                    
                    ColorfulPicker(selection: $isRegistered)
                    
                    NavigationLink(destination: HomeView(), isActive: self.$authSession.noErrorAppearDuringAuth) { Text("") }
                    
                    if isRegistered {
                        LoginView()
                    } else {
                        SignupView()
                    }
                    
                }.padding()
            }.navigationBarTitle("Welcome", displayMode: .inline)
        }.onAppear(perform: getUser)
    }
    //MARK: Functions
    
    func getUser() {
        authSession.listen()
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(AuthSessionStore())
    }
}
