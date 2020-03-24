//
//  SeriesTextFields.swift
//  GymNote
//
//  Created by Rafał Swat on 24/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SeriesTextFields: View {
    var repeats: Binding<[String]>
    var weights: Binding<[String]>
    var index: Int
    
    @State var reps: String
    @State var weight: String
    
    var body: some View {
        HStack {
            TextField("", text: self.$reps, onCommit: {
                self.repeats.wrappedValue[self.index] = self.reps
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            TextField("", text: self.$weight, onCommit: {
                self.weights.wrappedValue[self.index] = self.weight
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
}

struct SeriesTextFields_Previews: PreviewProvider {
    
    @State static var prevArray = ["1"]
    static var prevIndex = 0
    @State static var prevText = ""
    
    
    static var previews: some View {
        SeriesTextFields(repeats: $prevArray, weights: $prevArray, index: prevIndex, reps: prevText, weight: prevText)
    }
}

