//
//  ActionAlert.swift
//  GymNote
//
//  Created by Rafał Swat on 03/07/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//


import SwiftUI

struct ActionAlert: View {
    
    @Binding var showAlert: Bool
    var title: String
    var message: String
    var firstButtonTitle: String
    var secondButtonTitle: String
    var action: () -> Void
    
    var body: some View {
        
        VStack {
            Text(title)
                .padding(.vertical, 5)
                .font(.headline)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors:[Color.gray, Color.customDark, Color.gray]), startPoint: .trailing, endPoint: .leading))
            
            Divider()
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top)
            
            HStack {
                Group {
                    Button(action:{
                        self.showAlert = false
                    }) {
                        Text(secondButtonTitle)
                    }
                    .buttonStyle(RectangularButtonStyle(fromColor: .darkRed, toColor: .red, minWidth: 0, maxWidth: UIScreen.main.bounds.width/3, minHeight: 0, maxHeight: 35))
                        .padding()
                        
                    
                    
                    Button(action: {
                        self.action()
                    }) {
                        Text(firstButtonTitle)
                    }
                        .buttonStyle(RectangularButtonStyle(fromColor: .red, toColor: .orange, minWidth: 0, maxWidth: UIScreen.main.bounds.width/3, minHeight: 0, maxHeight: 35))
                        
                        .padding()
                        
                }
            }
        }
        .background(Color.gray)
        .cornerRadius(15)
        .padding()
        
        .cornerRadius(20)
        .padding()
    }
}

struct ActionAlert_Previews: PreviewProvider {
    
    @State static var prevShowAlert = true
    static var prevTitle = "Alert Title"
    static var prevMessage = "Alert Message"
    static var prevFirstButtonTitle = "Ok"
    static var prevSecondButtonTitle = "Cancel"

    
    static func prevAction() {
        print("Prev Alert Action")
    }
    
    
    static var previews: some View {
        
        ActionAlert(showAlert: $prevShowAlert,
                   title: prevTitle,
                   message: prevMessage,
                   firstButtonTitle: prevFirstButtonTitle,
                   secondButtonTitle: prevSecondButtonTitle,
                   action: prevAction)
    }
}
