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
    @State private var isRegistered = false
    
    //MARK: View
    var body: some View {
        NavigationView {
            KeyboardHost {
                VStack {
                    
                    Image("staticImage")
                    
                    ColorfulPicker(selection: $isRegistered)
                    
                    NavigationLink(destination: HomeView(), isActive: self.$session.noErrorAppearDuringAuth) { Text("") }
                    
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
        WelcomeView()
            .environmentObject(FireBaseSession())
    }
}
