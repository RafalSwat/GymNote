//
//  SeriesTextFields.swift
//  GymNote
//
//  Created by Rafał Swat on 11/08/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import Foundation
import SwiftUI

struct SeriesTextFields: View {
    
    var index: Int
    
    @State var reps: String
    @State var weight: String
    
    var decimalFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .none
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        f.alwaysShowsDecimalSeparator = true
        return f
    }()
    
    var body: some View {
        HStack {
            
            TextField("repeats", value: $reps, formatter: self.decimalFormatter, onEditingChanged: { edit in
                // Editing has finished
                if !edit {
                    print("COMMITED! \(self.reps)");
                }
            })
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
                        )
                .keyboardType(.decimalPad)
            TextField("weight", value: $weight, formatter: self.decimalFormatter, onEditingChanged: { edit in
                // Editing has finished
                if !edit {
                    print("COMMITED! \(self.weight)");
                }
            })
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
                        )
                .keyboardType(.decimalPad)


        }
    }
}

