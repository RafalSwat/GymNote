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
    
    @Binding var reps: Double
    @Binding var weight: Double
    
    var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    
    var body: some View {
        HStack {
            DecimalTextField("reps",
                             value: self.$reps)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
                    )
            DecimalTextField("weight",
                             value: self.$weight,
                             formatter: self.decimalFormatter)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
                )
            
        }
    }
    
    func action() {
        self.repeats.wrappedValue[self.index] = String(self.reps)
        self.weights.wrappedValue[self.index] = String(self.weight)
    }
}

struct Try_Previews: PreviewProvider {
    
    
    @State static var prevArray = ["1"]
    static var prevIndex = 0
    @State static var prevText = 12.0
    
    
    static var previews: some View {
        Try(repeats: $prevArray, weights: $prevArray, index: prevIndex, reps: $prevText, weight: $prevText)
    }
}
