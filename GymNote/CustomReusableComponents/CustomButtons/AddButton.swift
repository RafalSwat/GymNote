//
//  AddButton.swift
//  GymNote
//
//  Created by Rafał Swat on 01/03/2020.
//  Copyright © 2020 Rafał Swat. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var addButtonImage: Image = Image(systemName: "plus.circle")
    @Binding var addingMode: Bool
    
    var body: some View {
        Button(action: {
            self.addingMode.toggle()
        }) {
            HStack {
                
                self.addButtonImage
                    .font(.largeTitle)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                Spacer()
                Text("ADD EXERCISES")
                Spacer()
            }
            
            
            
        }.buttonStyle(RectangularButtonStyle())
    }
}

struct AddButton_Previews: PreviewProvider {
    
    @State static var prevAddingMode = false
    
    static var previews: some View {
        AddButton(addingMode: $prevAddingMode)
    }
}
