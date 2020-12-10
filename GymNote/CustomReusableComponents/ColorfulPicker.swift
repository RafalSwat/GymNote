//
//  ColorfulPicker.swift
//  GymNote
//
//  Created by Rafał Swat on 14/12/2019.
//  Copyright © 2019 Rafał Swat. All rights reserved.
//

import SwiftUI

struct ColorfulPicker: View {
    @Binding var selection: Bool
    var text1 = "Login"
    var text2 = "SignUp"

    
    var body: some View {
        Picker(selection: $selection, label: Text("Welcome")) {
            Text(text1).tag(true)
            Text(text2).tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(7)
        .padding(.bottom, 20)
        
    }
}

struct ColorfulPicker_Previews: PreviewProvider {
    @State static var selection: Bool = false
    
    static var previews: some View {
        ColorfulPicker(selection: $selection)
    }
}
