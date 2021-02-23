//
//  VerificationEmailAlert.swift
//  GymNote
//
//  Created by Rafał Swat on 22/02/2021.
//  Copyright © 2021 Rafał Swat. All rights reserved.
//

import SwiftUI

struct VerificationEmailAlert: View {
    
    @Binding var showAlert: Bool
    let title = "We sent an authentication link to the user's email address!"
    let message = "Please confirm the authenticity of the given address on your mail! After verification log in to the application."
    var signUpAction: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .padding(.vertical, 5)
                .font(.headline)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                //.background(LinearGradient(gradient: Gradient(colors:[Color.gray, Color.customDark, Color.gray]), startPoint: .trailing, endPoint: .leading))
            
            Divider()
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top)
            
            
            HStack {
               Spacer()
                    Button(action:{
                        self.signUpAction()
                        self.showAlert = false
                    }) {
                        Text("Ok")
                            //.foregroundColor(Color.orange)
                    }
                    .buttonStyle(RectangularButtonStyle(fromColor: Color.customLight, toColor: Color.customDark, minWidth: 0, maxWidth: UIScreen.main.bounds.width/3, minHeight: 0, maxHeight: 35))
                        .padding()
               Spacer()
                
            }
        }
        .background(LinearGradient(gradient: Gradient(colors:[Color.customLight, Color.customDark]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .cornerRadius(15)
        .padding()
    }
}
//
//struct VerificationEmailAlert_Previews: PreviewProvider {
//
//    @State static var prevShowAlert = true
//    static var prevTitle = "Alert Title"
//    static var prevMessage = "Alert Message"
//    static var prevFirstButtonTitle = "Ok"
//    static var prevSecondButtonTitle = "Cancel"
//
//
//    static func prevAction() {
//        print("!Action!")
//    }
//
//    static var previews: some View {
//        VerificationEmailAlert()
//    }
//}
