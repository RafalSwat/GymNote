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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var warningText = ""
    @State var showWarning = false
    @State var showForgotPassword = false
    @Binding var alreadySignIn: Bool
    
    //MARK: View
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
            
            SwitchableSecureField(placeHolder: "Password", secureText: $password)
            
            HStack {
                Spacer()
                Button(action: {
                    self.showForgotPassword.toggle()
                }, label: {
                   Text("Forgot Password?")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                }).padding(.horizontal)
            }
            
            if self.showWarning {
                Text(warningText)
                    .font(.caption)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(5)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if self.isNotEmpty() {
                    self.logIn()
                } else  {
                    self.showWarning = true
                }
            }) {
                HStack {
                    Image(systemName: "at")
                        .font(.headline)
                    Spacer()
                    Text("Login with email")
                    Spacer()
                }.padding(.horizontal)
            }
            .buttonStyle(RectangularButtonStyle())
            .padding(.top, 15)
            .padding(.bottom, 2.5)
            
            Button(action: {
                self.signInAnonymously()
            }) {
                HStack {
                    Image(systemName: "person.fill.questionmark")
                        .font(.headline)
                    Spacer()
                    Text("continue anonymously")
                    Spacer()
                }
                .padding(.horizontal)
                .foregroundColor(colorScheme == .light ? .black : .white)
            }
            .buttonStyle(RectangularButtonStyle(fromColor: .blendingInWithTheList,
                                                toColor: colorScheme == .light ? .customLight : .customDark))
            .padding(.top, 2.5)
            
            
            
           
        }.sheet(isPresented: self.$showForgotPassword, content: {
            ForgotPasswordView()
        })
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
    func signInAnonymously() {
        self.session.signInAnonymously { (errorDuringSignUp, errorDescription) in
            self.showWarning = errorDuringSignUp
            
            if !self.showWarning {
                self.alreadySignIn = true
                
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

struct LoginView_Previews: PreviewProvider {
    
    @State static var prevAlreadySignIn = false
    
    static var previews: some View {
        LoginView(alreadySignIn: $prevAlreadySignIn)
    }
}
