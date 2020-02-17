//
//  DoneConformAlert.swift
//  GymNote
//
//  Created by Rafał Swat on 14/02/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct DoneConformAlert: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var showAlert: Bool
    var alertTitle: String
    var alertMessage: String
    var alertAction: () -> Void
    
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text(alertTitle)
                .font(.title)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.customDark, Color.magnesium]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(Color.white)
                
            
            Text(alertMessage)
                .font(.headline)
                .padding()
            
            HStack {
                Group {
                    Button("Cancel", action:{
                        self.showAlert = false
                    })
                        .buttonStyle(RectangularButtonStyle(fromColor: .red, toColor: .customDark))
                        .padding()
                    
                    
                    Button("Conform", action: alertAction)
                        .buttonStyle(RectangularButtonStyle(fromColor: .green, toColor: .customDark))
                        .padding()
                }
            }.padding(.horizontal, 30)
            
        }
        .background(LinearGradient(gradient: Gradient(
            colors: [.gray ,.magnesium]),
                                   startPoint: .leading, endPoint: .trailing
        ))
            .cornerRadius(20)
            .shadow(color: Color(colorScheme == .light ? UIColor.black : UIColor.white), radius: 20)

    }
}

extension Color {
    static let customDark = Color("customDark")
    static let magnesium = Color("magnesium")
}

struct DoneConformAlert_Previews: PreviewProvider {
    @State static var prevShowAlert = true
    
    static var previews: some View {
        DoneConformAlert(showAlert: $prevShowAlert, alertTitle: "alertTitle", alertMessage: "alertMessage", alertAction: {
            print("DoneConformAlertPrev is showing")
        })
    }
}

