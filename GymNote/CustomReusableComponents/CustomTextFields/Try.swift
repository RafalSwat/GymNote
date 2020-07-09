//
//  Try.swift
//  GymNote
//
//  Created by Rafał Swat on 25/06/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct Try: View {
    
    var repeats: Binding<[String]>
    var weights: Binding<[String]>
    var index: Int
    
    @State var reps: String
    @State var weight: String
    
    var body: some View {
        HStack {
            CustomTextfield(text: self.$reps, keyType: .decimalPad, placeHolder: "  reps")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
                )

            CustomTextfield(text: self.$reps, keyType: .decimalPad, placeHolder: "  weight")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)

            )
        }
    }
    
    func action() {
        self.repeats.wrappedValue[self.index] = self.reps
        self.weights.wrappedValue[self.index] = self.weight
    }
}

struct Try_Previews: PreviewProvider {
    
    
    @State static var prevArray = ["1"]
    static var prevIndex = 0
    @State static var prevText = ""
    
    
    static var previews: some View {
        Try(repeats: $prevArray, weights: $prevArray, index: prevIndex, reps: prevText, weight: prevText)
    }
}
