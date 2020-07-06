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
                .font(.title)
                .frame(maxWidth: .infinity)
            
            Divider()
            
            Text(message)
            
            HStack {
                Group {
                    Button(action:{
                        self.showAlert = false
                    }) {
                        Text(secondButtonTitle)
                    }
                        .buttonStyle(RectangularButtonStyle())
                        .padding()
                        
                    
                    
                    Button(action: {
                        self.action()
                    }) {
                        Text(firstButtonTitle)
                    }
                        .buttonStyle(RectangularButtonStyle())
                        
                        .padding()
                        
                }
            }
        }
        
        .cornerRadius(20)
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
