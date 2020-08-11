//
//  Try.swift
//  GymNote
//
//  Created by Rafał Swat on 25/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct Try: View {
    
    var index: Int
    
    @State var reps: String
    @State var weight: String
    
    var body: some View {
        HStack {
            NumberTextField(text: self.$reps, keyType: .decimalPad, placeHolder: "  reps")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
                )

            NumberTextField(text: self.$reps, keyType: .decimalPad, placeHolder: "  weight")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)

            )
        }
    }
}

struct Try_Previews: PreviewProvider {
    
    static var prevIndex = 0
    @State static var prevText = ""
    
    
    static var previews: some View {
        Try(index: prevIndex, reps: prevText, weight: prevText)
    }
}
