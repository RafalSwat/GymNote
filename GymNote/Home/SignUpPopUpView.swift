//
//  SignUpPopUpView.swift
//  GymNote
//
//  Created by Rafał Swat on 08/03/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SignUpPopUpView: View {
    
    @EnvironmentObject var session: FireBaseSession
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var goToSignIn: Bool
    @Binding var alreadySignIn: Bool
    @Binding var showAlert: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State var showWarning = false
    @State var warningText = ""

    var body: some View {
        ZStack {
        VStack {
            Image("staticImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
            
            SwitchableSecureField(placeHolder: "Password", secureText: $password)
            
            SwitchableSecureField(placeHolder: "repeat password", secureText: $repeatPassword)
            
            if self.showWarning {
                Text(warningText)
                    .font(.caption)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .multilineTextAlignment(.center)
                
            }
            VStack {
                Button(action: {
                    if self.isNotEmpty() && self.arePasswordEqual() {
                        self.mereAnonymousUserwithEmail()
                        
                        
                    } else if !self.isNotEmpty() {
                        self.showWarning = true
                        
                    } else if !self.arePasswordEqual() {
                        self.showWarning = true
                        
                    }
                }) {
                    HStack {
                        Image(systemName: "at")
                            .font(.headline)
                        Spacer()
                        Text("SignUp with email")
                        Spacer()
                    }.padding(.horizontal)
                }
                .buttonStyle(RectangularButtonStyle())
                .padding(.bottom, 2.5)
            }
            .padding(.top, 8)
            
        }.padding()
        if showAlert {
            Color.black.opacity(0.7)
            
            VerificationEmailAlert(showAlert: self.$showAlert,
                                   signUpAction: {
                                        self.goToSignIn = false
                                        self.alreadySignIn.toggle()
                                   })
        
        }
    }
        
    }
    func arePasswordEqual() -> Bool {
        if password == repeatPassword {
            print("Passwords are equal!")
            return true
        } else {
            self.warningText = "Error: passwords are not equal!"
            return false
        }
    }
    
    func isNotEmpty() -> Bool {
        if self.email.isEmpty {
            self.warningText = "Error: email field is Empty!"
            return false
        } else if self.password.isEmpty {
            self.warningText = "Error: password field is Empty!"
            return false
        } else if self.repeatPassword.isEmpty {
            self.warningText = "Error: repeated password field is Empty!"
            return false
        } else {
            print("Confirm: Ther is no empty fields")
            return true
        }
    }
    
    func mereAnonymousUserwithEmail() {
        self.session.mergeAnonymousUserWithEmail(email: email, password: password) { errorDuringMerging, errorDescription in
            self.showWarning = errorDuringMerging
            
            if !self.showWarning {
                self.showAlert = true
            } else {
                if let fbrError = errorDescription {
                    self.warningText = fbrError
                    
                } else {
                    self.warningText = "Unknow error... please try again"
                }
            }
        }
        
    }
}
