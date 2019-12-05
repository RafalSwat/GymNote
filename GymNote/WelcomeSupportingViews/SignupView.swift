//
//  SignupView.swift
//  GymNote
//
//  Created by Rafał Swat on 05/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var matchPassword: Bool = false
    
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
                //TODO: SignUp functionality with firebase and env.obj.
                self.comparePasswords(firstPassword: self.password, secondPassword: self.repeatPassword)
                
            })
            .frame(minWidth: CGFloat(0), maxWidth: .infinity)
            .border(Color.gray, width: CGFloat(2))
            .cornerRadius(CGFloat(5))
            .font(.headline)
        }
    }
    
    func comparePasswords(firstPassword: String, secondPassword: String) {
        if firstPassword == secondPassword {
            self.matchPassword = true
            print("Signup Stuff")
        } else {
            self.matchPassword = false
            print("Error: passwords are not equal")
        }
    }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
