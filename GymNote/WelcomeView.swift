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
    @State private var isRegistered = false
    @State private var noErrorAppear: Bool = false

    
    //MARK: View
    var body: some View {
        NavigationView {
            KeyboardHost {
                VStack {
                    
                    Image("staticImage")
                    
                    ColorfulPicker(selection: $isRegistered)
                    
                    NavigationLink(destination: HomeView(), isActive: self.$noErrorAppear) { Text("") }
                    
                    if isRegistered {
                        LoginView(signInWithoutError: $noErrorAppear)
                    } else {
                        SignupView(signUpWithoutError: $noErrorAppear)
                    }
                    
                }.padding()
            }
            .navigationBarTitle("Welcome", displayMode: .inline)
        }
    }
    //MARK: Functions
        
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
