//
//  LoginView.swift
//  GymNote
//
//  Created by Rafał Swat on 05/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: Properties
    @EnvironmentObject var session: FireBaseSession
    
    @State private var email: String = ""//"a@a.com"
    @State private var password: String = ""//"123456"
    @State var warningText = ""
    @Binding var alreadySignIn: Bool
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
            
            SwitchableSecureField(placeHolder: "Password", secureText: $password)
            
            Button("Login", action: {
                if self.isNotEmpty() {
                    self.logIn()
                    
                    if !self.session.errorAppearDuringAuth {
                        self.alreadySignIn = true
                        self.session.errorAppearDuringAuth = false
                    } else {
                        if let fbrError = self.session.errorDiscription {
                            self.session.errorAppearDuringAuth = true
                            self.warningText = fbrError
                            
                        }
                    }
    
                } else if !self.isNotEmpty() {
                    self.session.errorAppearDuringAuth = true
                }
            })
                .buttonStyle(RectangularButtonStyle())
                .padding(.top, 15)
            
            if self.session.errorAppearDuringAuth{
                Text(warningText)
                    .font(.caption)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .multilineTextAlignment(.center)
                
            }
        }
    }
    
    //MARK: Functions
    
    func isNotEmpty() -> Bool {
        if self.email.isEmpty {
            self.warningText = "Error: email field is Empty!"
            return false
        } else if self.password.isEmpty {
            self.warningText = "Error: password field is Empty!"
            return false
        } else {
            print("Confirm: Ther is no empty fields")
            return true
        }
    }
    
    func logIn() {
        self.session.signIn(email: email, password: password)
    }
}

struct LoginView_Previews: PreviewProvider {
    
    @State static var prevAlreadySignIn = false
    
    static var previews: some View {
        LoginView(alreadySignIn: $prevAlreadySignIn)
    }
}