//
//  WelcomeView.swift
//  GymNote
//
//  Created by Rafał Swat on 04/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var isRegistered = false
    
    var body: some View {
        KeyboardHost {
            VStack {
                Text("Welcome!")
                    .font(.title)
                    .fontWeight(.medium)
                Image("staticImage")

                Picker(selection: $isRegistered, label: Text("Welcome")) {
                    Text("Login").tag(true)
                    Text("SignUp").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 20)
                    
                if isRegistered {
                    LoginView()
                } else {
                    SignupView()
                }
                
            }.padding()
        }
    }
        
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
