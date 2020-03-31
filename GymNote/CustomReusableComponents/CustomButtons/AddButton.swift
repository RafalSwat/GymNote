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
    var addButtonText: String = "ADD EXERCISES"
    var action: () -> Void = {}
    var fromColor = Color.orange
    var toColor = Color.red
    @Binding var addingMode: Bool

    
    var body: some View {
        Button(action: {
            self.addingMode.toggle()
            self.action()
        }) {
            HStack {
                
                self.addButtonImage
                    .font(.largeTitle)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .padding()
                Spacer()
                Text(addButtonText)
                Spacer()
            }

        }.buttonStyle(RectangularButtonStyle(fromColor: self.fromColor, toColor: self.toColor))
    }
}

struct AddButton_Previews: PreviewProvider {
    
    @State static var prevAddingMode = false
    
    static var previews: some View {
        AddButton(action: { print("addButton Action!")}, addingMode: $prevAddingMode)
    }
}
