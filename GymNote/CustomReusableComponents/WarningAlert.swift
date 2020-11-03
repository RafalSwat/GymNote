//
//  WarningAlert.swift
//  GymNote
//
//  Created by Rafał Swat on 03/07/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct WarningAlert: View {
    
    @Binding var showAlert: Bool
    var title: String
    var message: String
    var buttonTitle: String
    //var action: () -> Void
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .padding(.vertical, 5)
                .font(.headline)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors:[Color.gray, Color.customDark, Color.gray]), startPoint: .trailing, endPoint: .leading))
            
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top)
                

                    Button(action: {

                        withAnimation {
                            self.showAlert = false
                            //self.action()
                        }
                    }) {
                        Text(buttonTitle)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(RectangularButtonStyle(fromColor: .red, toColor: .orange, minWidth: 0, maxWidth: UIScreen.main.bounds.width/3, minHeight: 0, maxHeight: 35))
                        
                    .padding()

        }
        .background(Color.gray)
        .cornerRadius(15)
        .padding()
    }
}

struct WarningAlert_Previews: PreviewProvider {
    
    @State static var prevShowAlert = true
    static var prevTitle = "Alert Title"
    static var prevMessage = "Alert Message"
    static var prevButtonTitle = "Ok"
    
    
    static var previews: some View {
        WarningAlert(showAlert: $prevShowAlert,
                     title: prevTitle,
                     message: prevMessage,
                     buttonTitle: prevButtonTitle)
    }
}
