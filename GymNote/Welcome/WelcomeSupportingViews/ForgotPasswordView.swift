//
//  ForgotPasswordView.swift
//  GymNote
//
//  Created by Rafał Swat on 18/02/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var session: FireBaseSession
    
    @State private var email: String = ""
    @State var warningText = ""
    @State var showWarning: Bool?
    
    var body: some View {
        VStack {
            Text("Forgot your password?")
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.orange)
                .padding()
            Text("No worries. Enter your email address and we will send you a link to reset your password. ")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.emailAddress)
                .padding()
            
            if self.showWarning == true {
                Text(warningText)
                    .font(.caption)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
            } else if self.showWarning == false {
                Text(warningText)
                    .font(.caption)
                    .foregroundColor(.green)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                //restet pasword mechanic
                self.showWarning = false
                self.warningText =  "Reset password email has been successfully sent!"
            }, label: {
                HStack {
                    Image(systemName: "envelope")
                        .font(.headline)
                    Spacer()
                    Text("Send Request")
                    Spacer()
                }.padding(.horizontal)
            })
            .buttonStyle(RectangularButtonStyle())
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    func resetPassword(email: String) {
        self.session.restetPassword(email: email) { (errorDuringReset, errorMessage) in
            if errorDuringReset {
                self.showWarning = true
                self.warningText = errorMessage ?? "Unknow error occur during reset password!"
            } else {
                self.showWarning = false
                self.warningText = errorMessage ?? ""
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
