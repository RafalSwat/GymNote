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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State var showWarning = false
    @State var warningText = ""
    @State var isEmailVerified = false
    @State var showAlert = false
    @Binding var alreadySignIn: Bool
    @Binding var isRegistered: Bool
    
    //MARK: View
    var body: some View {
        ZStack {
            VStack {
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
                            self.signUpWithEmail()
                            
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
                    
                }
                .padding(.top, 8)
                
            }
            if showAlert {
                VerificationEmailAlert(showAlert: self.$showAlert,
                                       signUpAction: {
                                        self.isRegistered.toggle()
                                       })
            }
        }
    }
    
    
    
    //MARK: Functions
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
    
    func signUpWithEmail() {
        self.session.signUp(email: email, password: password, completion: { errorDuringSignUp, errorDescription in
            self.showWarning = errorDuringSignUp
            
            if !self.showWarning {
                
                self.showAlert = true
                
            } else {
                if let fbrError = errorDescription {
                    self.warningText = fbrError
                    
                } else {
                    self.warningText = "Unknow error... please try again"
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


struct SignupView_Previews: PreviewProvider {
    
    @State static var prevAlreadySignIn = false
    @State static var previsRegistred = false
    
    static var previews: some View {
        SignupView(alreadySignIn: $prevAlreadySignIn,
                   isRegistered: $previsRegistred)
    }
}
