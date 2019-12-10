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
    @State private var email: String = ""
    @State private var password: String = ""
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            Button("Login", action: {
                //TODO: login functionality with firebase and env.obj.
                print("Login Stuff")
            })
            .frame(minWidth: 0, maxWidth: .infinity)
            .border(Color.gray, width: 2)
            .cornerRadius(5)
            .font(.headline)
        }
    }
    
    //MARK: Functions
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
    }
}
