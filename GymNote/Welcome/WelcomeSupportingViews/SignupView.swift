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
    @EnvironmentObject var session: FireBaseSession
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @Binding var alreadySignIn: Bool
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
            
            SwitchableSecureField(placeHolder: "Password", secureText: $password)
            
            SwitchableSecureField(placeHolder: "repeat password", secureText: $repeatPassword)

            Button("SignUp", action: {
                if self.isNotEmpty() && self.arePasswordEqual() {
                    self.signUp()
                    self.alreadySignIn = true
                }
            })
                .buttonStyle(RectangularButtonStyle())
                .padding(.top, 15)
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
        self.session.signUp(email: email, password: password)
    }
}



struct SignupView_Previews: PreviewProvider {
    
    @State static var prevAlreadySignIn = false
    
    static var previews: some View {
        SignupView(alreadySignIn: $prevAlreadySignIn)
    }
}