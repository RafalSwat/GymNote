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
    @State var errorDuringAuthorization = false
    
    //MARK: View
    var body: some View {
        KeyboardHost {
            ZStack {
                
                VStack {
                    Image("staticImage")
                    
                    ColorfulPicker(selection: $isRegistered)
                    
                    if isRegistered {
                        LoginView(alreadySignIn: $alreadySignIn)
                    } else {
                        SignupView(showWarning: self.$errorDuringAuthorization, alreadySignIn: $alreadySignIn)
                    }
            }
               if errorDuringAuthorization {
                    ZStack {
                        WarningAlert(showAlert: $errorDuringAuthorization, title: "Warninig", message: "There are still empty fields, please fill them up!", buttonTitle: "ok", action: {print("Fuck yeah!")})
                    }
                }
                
                
            }
                .padding()
                .edgesIgnoringSafeArea(.vertical)
        }
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
