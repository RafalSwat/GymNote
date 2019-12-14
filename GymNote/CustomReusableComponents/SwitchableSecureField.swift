//
//  SwitchableSecureField.swift
//  GymNote
//
//  Created by Rafał Swat on 12/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI


struct SwitchableSecureField: View {
    var placeHolder: String
    @Binding var secureText: String
    @State private var hidePassword: Bool = true
    
    var body: some View {
        ZStack {
            if hidePassword {
                SecureField(placeHolder, text: $secureText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                TextField(placeHolder, text: $secureText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
                

            HStack {
                Spacer()
                Button(action: {
                    withAnimation {self.hidePassword.toggle()}
                }) {
                    if hidePassword {
                        Image(systemName: "eye")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "eye.slash")
                            .foregroundColor(.orange)
                    }
                }.padding()
            }
        }
    }
}


struct SwitchableSecureField_Previews: PreviewProvider {
    static var placeHolderText: String = "enter password"
    @State static var text: String = "password"

    static var previews: some View {
        SwitchableSecureField(
            placeHolder: placeHolderText,
            secureText: $text)
    }
}
