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
    @Binding var alreadySignIn: Bool
    
    //MARK: View
    var body: some View {
        
        VStack {
            Image("staticImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ColorfulPicker(selection: $isRegistered)
            
            if isRegistered {
                LoginView(alreadySignIn: $alreadySignIn)
            } else {
                SignupView(alreadySignIn: $alreadySignIn,
                           isRegistered: self.$isRegistered)
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.vertical)
        
        .navigationBarTitle("Welcome", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
    
}


struct WelcomeView_Previews: PreviewProvider {
    
    @State static var prevAlreadySignIn = false
    
    static var previews: some View {
        NavigationView {
            WelcomeView(alreadySignIn: $prevAlreadySignIn)
                .environmentObject(FireBaseSession())
        }
    }
}
