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
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var warningText = ""
    @State var showWarning = false
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
                } else  {
                    self.showWarning = true
                }
            })
                .buttonStyle(RectangularButtonStyle())
                .padding(.top, 15)
            
            if self.showWarning{
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
        self.session.signIn(email: email, password: password, completion: { errorDuringLogin, errorDescription in
            self.showWarning = errorDuringLogin
            
            if !self.showWarning {
                self.alreadySignIn = true
            } else {
                if let fbrError = errorDescription {
                    self.warningText = fbrError
                }
            }
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    
    @State static var prevAlreadySignIn = false
    
    static var previews: some View {
        LoginView(alreadySignIn: $prevAlreadySignIn)
    }
}
