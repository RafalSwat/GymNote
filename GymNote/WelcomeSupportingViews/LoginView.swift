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
    @EnvironmentObject var authSession: AuthSessionStore
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
            
            SwitchableSecureField(placeHolder: "Password", secureText: $password)

            Button("Login", action: {
                if self.isNotEmpty() {
                    self.logIn()
                }
            })
                .buttonStyle(RectangularButtonStyle())
                .padding(.top, 15)
        }
    }
    
    //MARK: Functions
    
    func isNotEmpty() -> Bool {
        if self.email.isEmpty {
            print("Error: email field is Empty!")
            return false
        } else if self.password.isEmpty {
            print("Error: password field is Empty!")
            return false
        } else {
            print("Confirm: Ther is no empty fields")
            return true
        }
    }
    
    func logIn() {
        self.authSession.signIn(email: email, password: password)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
