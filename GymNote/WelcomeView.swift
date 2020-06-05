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
    @EnvironmentObject var session: FireBaseSession
    @State private var isRegistered = true
    
    //MARK: View
    var body: some View {
        NavigationView {
            KeyboardHost {
                VStack {
                    
                    Image("staticImage")
                    
                    ColorfulPicker(selection: $isRegistered)
                    
                    NavigationLink(destination: MainContainer(), isActive: self.$session.noErrorAppearDuringAuth) { Text("") }
                    
                    if isRegistered {
                        LoginView()
                    } else {
                        SignupView()
                    }
                    
                }.padding()
            }.navigationBarTitle("Welcome", displayMode: .inline)
        }
    }
    
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeView()
                .environmentObject(FireBaseSession())
        }
    }
}
