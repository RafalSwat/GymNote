//
//  SignupView.swift
//  GymNote
//
//  Created by Rafał Swat on 05/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    //MARK: Properties
    @EnvironmentObject var authSession: AuthSessionStore
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var loading = false
    @State private var error = false
    
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            SecureField("Repeat password", text: $repeatPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            
            
            Button("SignUp", action: {
                self.signUp(email: self.email, password: self.password)
                Text("Sign Up")
            })
            .frame(minWidth: CGFloat(0), maxWidth: .infinity)
            .border(Color.gray, width: CGFloat(2))
            .cornerRadius(CGFloat(5))
            .font(.headline)
        }
    }
    
    //MARK: Functions
    func equalPasswords(firstPassword: String, secondPassword: String) -> Bool {
        if firstPassword == secondPassword {
            print("Passwords are equal!")
            return true
        } else {
            print("Error: passwords are not equal!")
            return false
        }
    }
    
    func signUp(email: String, password: String) {
        if !self.email.isEmpty &&
            !self.password.isEmpty &&
            !self.repeatPassword.isEmpty &&
            self.equalPasswords(firstPassword: self.password, secondPassword: self.repeatPassword) {
            self.authSession.signUp(
                email: self.email,
                password: self.password) { (authDataResult, error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        self.email = ""
                        self.password = ""
                    }
            }
        }
    }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
