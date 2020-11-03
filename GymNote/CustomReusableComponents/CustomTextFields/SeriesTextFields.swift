//
//  SeriesTextFields.swift
//  GymNote
//
//  Created by Rafał Swat on 28/10/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct SeriesTextFields: View {
    
    @Binding var repetitions: String
    @Binding var weight: String

    var body: some View {
        HStack {
            TextField("repetitions", text: $repetitions)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            TextField("weight", text: $weight)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct SeriesTextFields_Previews: PreviewProvider {
    
    @State static var prevRep = ""
    @State static var prevWeight = ""
    @State static var prevSeries = Series()
    static var prevIndex = 1
    
    static var previews: some View {
        SeriesTextFields(repetitions: $prevRep,
                         weight: $prevWeight)
    }
}
