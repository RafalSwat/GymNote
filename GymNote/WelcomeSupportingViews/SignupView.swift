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
    @Binding var signUpWithoutError: Bool
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SwitchableSecureField(placeHolder: "Password", secureText: $password)
            
            SwitchableSecureField(placeHolder: "repeat password", secureText: $repeatPassword)
            
            Button("SignUp", action: {
                if self.isNotEmpty() && self.arePasswordEqual() {
                    self.signUp()
                }
            })
                .frame(minWidth: CGFloat(0), maxWidth: .infinity)
                .border(Color.gray, width: CGFloat(2))
                .cornerRadius(CGFloat(5))
                .font(.headline)
        }

    }
    
    //MARK: Functions
    func arePasswordEqual() -> Bool {
        if password == repeatPassword {
            print("Passwords are equal!")
            return true
        } else {
            print("Error: passwords are not equal!")
            return false
        }
    }
    
    func isNotEmpty() -> Bool {
        if self.email.isEmpty {
            print("Error: email field is Empty!")
            return false
        } else if self.password.isEmpty {
            print("Error: password field is Empty!")
            return false
        } else if self.repeatPassword.isEmpty {
            print("Error: repeated password field is Empty!")
            return false
        } else {
            print("Confirm: Ther is no empty fields")
            return true
        }
    }
    
    func signUp() {
        self.authSession.signUp(
            email: self.email,
            password: self.password) {(authDataResult, error) in
                if error != nil {
                    print(error.debugDescription)
                    self.signUpWithoutError = false
                } else {
                    self.email = ""
                    self.password = ""
                    self.repeatPassword = ""
                    self.signUpWithoutError = true
                    print("Registration is completed!")
                    
                }
            }
    }
}



struct SignupView_Previews: PreviewProvider {
    @State static var signUpWithoutError: Bool = false
    
    static var previews: some View {
        SignupView(signUpWithoutError: $signUpWithoutError)
    }
}
